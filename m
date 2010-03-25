Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:12725 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752006Ab0CYFtG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 01:49:06 -0400
Received: from vs3010.wh2.ocn.ne.jp (125.206.180.173)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0347876143
	for <linux-wireless@vger.kernel.org>; Thu, 25 Mar 2010 14:49:03 +0900 (JST)
Subject: [PATCH 00/10] ANI for ath5k
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, bob@bobcopeland.com,
	ath5k-devel@lists.ath5k.org, lrodriguez@atheros.com,
	mickflemm@gmail.com
Date: Thu, 25 Mar 2010 14:48:58 +0900
Message-ID: <20100325054603.10697.48915.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is ANI for ath5k. I have looked ath both the HAL and ath9k sources, while
implementing this, so the basic algorithm is the same. A notable difference is
that i do everything in a tasklet, while ath9k and HAL do larger parts in the
interrupt handler. Also i have only one routine for raising immunity, while
ath9k/HAL have separate triggers for CCK and OFDM errors.

Notes/Questions:

- HAL and ath9k use ANI status per channel. This might be useful if we often
  change channel, but this is not the case, as far as i can see. Any other
  reason for that?

- HAL and ath9k use only different 2 values in a 5 value array of noise
  immunity levels (making it essentially an on/off setting) while there are 5
  levels mentioned in the ANI documents. I guess there must be a reason for
  this - No?

- Why is CCK weak signal detection never used (neither turned on or off)?

- There is some confusion which initial values to use. The HAL uses all 0 and
  ofdm weak signal detection enabled. ath9k has all 0 for AP mode (including
  ofdm weak sig off), while using ofdm weak sig on and a spur level of 7 for
  STA mode.

- Also there is some inconsistency about which parameters to control in AP
  mode: ath9k only use spur and firstep in 2GHz bands and no ANI control at all
  in 5GHz!? the HAL uses noise and spur in both bands, but no fir control. for
  now, i use noise, spur and fir in AP mode.

- In some situations it is good to be able to manually control sesitivity (e.g.
  tuning long-distance links; not trusting the ANI algo in general ;)), so i
  would like to export ANI controls to userspace. Right now this is possible
  thru debugfs, but this is just for testing. How should the ANI settings be
  controlled properly? iw? configs? sysfs? What's the interface of choice
  nowadays?

TODO / Ideas:

- Improve beacon averaging algorithm for IBSS: Maybe we should keep track of
  the average RSSI on a per-node basis and use the minimum of those in order
  not to loose far away nodes? The other option would be to limit the
  parameters we control similar to AP mode.
 
- Older HW (srev < 0x59) use rx filter and reports phy errors as they appear in
  the rx descriptors. All is in place for this to work, but i never saw the
  "right" errors (OFDM and CCK timing), even though i'm pretty sure i should get
  them. This needs to be tested and debugged more, but i have to focus on newer
  hardware now.

- Maybe we could compare the "busy time" to the "listen time" and this way
  recognize if we have many false detects (- this is how i originally found out
  that i need to work on ANI).

I hope that this will solve thruput problems! For me it nearly doubled thruput
in a noisy 2Ghz band. :)

bruno

---

Bruno Randolf (10):
      ath5k: remove static calibration interval variable
      ath5k: remove the use of SWI interrupt
      ath5k: optimize ath5k_hw_calibration_poll
      ath5k: move ath5k_hw_calibration_poll to base.c
      ath5k: keep beacon RSSI average
      ath5k: initialize default noise floor
      ath5k: simplify MIB counters
      ath5k: update phy errors codes
      ath5k: add capability flag for phyerror counters
      ath5k: Adaptive Noise Immunity (ANI) Implementation


 drivers/net/wireless/ath/ath5k/Makefile |    1 
 drivers/net/wireless/ath/ath5k/ani.c    |  741 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath5k/ani.h    |  104 ++++
 drivers/net/wireless/ath/ath5k/ath5k.h  |   68 ++-
 drivers/net/wireless/ath/ath5k/attach.c |    2 
 drivers/net/wireless/ath/ath5k/base.c   |   97 +++-
 drivers/net/wireless/ath/ath5k/base.h   |   20 +
 drivers/net/wireless/ath/ath5k/caps.c   |    6 
 drivers/net/wireless/ath/ath5k/debug.c  |  170 +++++++
 drivers/net/wireless/ath/ath5k/debug.h  |    2 
 drivers/net/wireless/ath/ath5k/desc.c   |    1 
 drivers/net/wireless/ath/ath5k/desc.h   |   35 +
 drivers/net/wireless/ath/ath5k/pcu.c    |   40 +-
 drivers/net/wireless/ath/ath5k/phy.c    |   22 -
 drivers/net/wireless/ath/ath5k/reg.h    |   36 +-
 15 files changed, 1237 insertions(+), 108 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath5k/ani.c
 create mode 100644 drivers/net/wireless/ath/ath5k/ani.h

-- 
Signature

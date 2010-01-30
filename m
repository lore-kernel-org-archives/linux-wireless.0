Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41164 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783Ab0A3A66 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2010 19:58:58 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/2] cfg80211: add regulatory suspend/resume support
Date: Fri, 29 Jan 2010 19:58:55 -0500
Message-Id: <1264813137-4478-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding suspend and resume support for the new regulatory framework
has been on the TODO list for a while now but never got around to it
until now. It turns out there is no easy way on cfg80211 to do something
globally for suspend and resume, suspend and resume is device specific.
One way to resolve this then is to make the necessary regulatory changes
upon disconnection from all BSSes. This has the added benefit of clearing
stale regulatory information upon *any* disconnection, not just upon
suspend and resume.

It also paves the way to allow us to let users set the regulatory
domain manually a second time and actually take effect, but there are
a few questions we'd have to address before adding that support, namely:

  a) Do we disconnect you form all your BSSes if you change
     the regulatory domain manually?
  b) If we don't disconnect you what do we do if your new regulatory
     domain disallows your currently used channel?

Let me know what you think of this, do we even want to add support
for allowing to change the regulatory domain twice if disconnected?
Maybe we could just only enable it if all devices are disconnected?

Just one note, if cfg80211 calls CRDA twice I noticed only the second
response is processed. I do see both requests going out though so
either kobject_uevent_env() drops the first one or userspace ignores
it for some reason. This is not be a regression, this happens even
prior to this patch. Upon initialization for example if you set
the ieee80211_regdom to "DE" you would get:

cfg80211: Calling CRDA to update world regulatory domain
cfg80211: Calling CRDA for country: DE
cfg80211: Regulatory domain changed to country: DE
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
    (5150000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
    (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)

Its not that big of an issue but it still would be good
to figure this out. That's left for something to look at some
other time.

Please give this small patch series some good testing.

Luis R. Rodriguez (2):
  cfg80211: avoid flushing the global workqueue for core reg hints
  cfg80211: add regulatory hint disconnect support

 include/net/regulatory.h |    1 +
 net/wireless/reg.c       |  161 ++++++++++++++++++++++++++++++++++++++++++++--
 net/wireless/reg.h       |   18 +++++
 net/wireless/sme.c       |   40 +++++++++++
 4 files changed, 214 insertions(+), 6 deletions(-)


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:50164 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaHOXnG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Aug 2014 19:43:06 -0400
Received: by mail-wi0-f176.google.com with SMTP id bs8so1461440wib.3
        for <linux-wireless@vger.kernel.org>; Fri, 15 Aug 2014 16:43:04 -0700 (PDT)
MIME-Version: 1.0
From: Avery Pennarun <apenwarr@gmail.com>
Date: Fri, 15 Aug 2014 19:42:44 -0400
Message-ID: <CAHqTa-10bc+AtFbifObfqHXwzfcbrA5w9Z6LL53kUdDWeq=7ig@mail.gmail.com> (sfid-20140816_014317_976760_2D497371)
Subject: Best choice of primary channels when using 40- or 80 MHz wide channels
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I'm pretty confused about how to select the "primary" channel when
using wide channels with 802.11ac (and also 802.11n, really).  My
hostapd contains a section like this:

hw_mode=a
channel=149
country_code=US
ieee80211d=1
ieee80211h=1
ieee80211n=1
ieee80211ac=1
ht_capab=[HT20][HT40+][RX-STBC1]
vht_capab=[MAX-A-MPDU-LEN-EXP4]
vht_oper_chwidth=1
vht_oper_centr_freq_seg0_idx=155

If I understand correctly, this will have the following results:
- at 20 MHz, it will use channel 149
- at 40 MHz, it will use channels 149+153 (HT40+)
- at 80 MHz, it will use channels 149+153+157+161 (centr_freq_seg0_idx)

This is fine when I'm the only AP around.  But let's imagine I'm in a
crowded apartment building with lots of APs, and various clients
support only 20 MHz channel width (increasingly rare), or 20/40, or
20/40/80.  In such a situation, we'd like to spread around the APs so
that clients that can only do 20 or 40 don't always fall back to
channel 149 or 149+153; otherwise we're just wasting tons of empty
space on channels 157 and 161.

The obvious way to do this would be to try a configuration like this (HT40-):

channel=153
ht_capab=[HT20][HT40-][RX-STBC1]
vht_capab=[MAX-A-MPDU-LEN-EXP4]
vht_oper_chwidth=1
vht_oper_centr_freq_seg0_idx=155

or perhaps this (40 Mhz uses upper half instead of lower half):

channel=157
ht_capab=[HT20][HT40+][RX-STBC1]
vht_capab=[MAX-A-MPDU-LEN-EXP4]
vht_oper_chwidth=1
vht_oper_centr_freq_seg0_idx=155

But when I try to do this, hostapd seems to abort and claim it can't
register to use the channels.  Am I doing something wrong?  Is it
hostapd version related?

Also, hostapd contains code to swap the primary/secondary 20 MHz
channels in the 40 MHz channel, based on what other APs are around.
If I read correctly, it seems to want to use the same primary channel
as everyone else.  Wouldn't it be better to equailze things to try to
get about half the APs using each sub channel?

Any advice on this topic is very welcome.  Thanks!

Have fun,

Avery

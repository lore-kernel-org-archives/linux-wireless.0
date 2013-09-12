Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:46454 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab3ILOAG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Sep 2013 10:00:06 -0400
Received: by mail-bk0-f43.google.com with SMTP id mz13so4293456bkb.30
        for <linux-wireless@vger.kernel.org>; Thu, 12 Sep 2013 07:00:05 -0700 (PDT)
MIME-Version: 1.0
From: Adrien Decostre <ad.decostre@gmail.com>
Date: Thu, 12 Sep 2013 15:59:24 +0200
Message-ID: <CAOtFK_VzuMox3hCZGVf8jRgKfHCVbfUiGk3jN8=TsmSOmivj_w@mail.gmail.com> (sfid-20130912_160012_257005_22B3E570)
Subject: Huge value read when requesting NL80211_SURVEY_INFO_CHANNEL_TIME_BUSY
To: linux-wireless@vger.kernel.org
Cc: sarah.rumpel@mailbox.tu-dresden.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,


We are currently doing some tests to retrieve the channel busy time,
Rx time and Tx time from the ath9k driver. For this purpose, we
started our implementation from the initial ACS algorithm
implementation provided at https://github.com/mcgrof/acs.

The data are read in the following way:
channel_time_busy = nla_get_u64(sinfo[NL80211_SURVEY_INFO_CHANNEL_TIME_BUSY]);
channel_time_rx = nla_get_u64(sinfo[NL80211_SURVEY_INFO_CHANNEL_TIME_RX]);
channel_time_tx = nla_get_u64(sinfo[NL80211_SURVEY_INFO_CHANNEL_TIME_TX]);

In most of the cases, the received data are OK but when generating
heavy interferences (actually when saturating the channel), very huge
values are read. For example, the
NL80211_SURVEY_INFO_CHANNEL_TIME_BUSY for 3 consecutive measurements
was 439270ms, 439411ms and 439555ms while the interface should not
have listened to this channel for more than 60ms.


Would anyone have already encountered a similar issue with the ath9k driver?
Does the driver do some accumulation over time and should a reset be
needed before doing any measurement?


I thank you in advance for any help.


Best regards


Adrien

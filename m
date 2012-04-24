Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41467 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421Ab2DXHMk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 03:12:40 -0400
Received: by iadi9 with SMTP id i9so592700iad.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Apr 2012 00:12:40 -0700 (PDT)
MIME-Version: 1.0
From: Andrew Chant <andrew.chant@gmail.com>
Date: Tue, 24 Apr 2012 00:11:59 -0700
Message-ID: <CANugF37WSOdHODRXOb6nnBCh5HMTTUqf0VpyPuTDdNK80-LkAQ@mail.gmail.com> (sfid-20120424_091243_797078_2D2A8AAD)
Subject: AP mode my ath9k broke between 3.3 and 3.4-rc2
To: Johannes Berg <johannes.berg@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
 my Atheros AR9300 PCIe card (168c:0030) stopped working as an AP on
the 5GHz band between 3.3 and 3.4-rc2.
After 14 git bisects, I believe I have narrowed it down to the following patch:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=293702a3fb75832613e2af097bdc3ac8ef775b33

mac80211: use common radiotap code for cooked monitors

Prior to this change, everything works.  After this change, an Intel
Corporation Centrino Advanced-N 6205 is able to see the AP using
"iwlist wlan0 scan", but the following shows up in dmesg when trying
to associate (on the intel side):

[ 7636.834579] wlan0: direct probe to 90:f6:52:0d:0a:5e timed out
[ 7644.201671] wlan0: direct probe to 90:f6:52:0d:0a:5e (try 1/3)
[ 7644.400767] wlan0: direct probe to 90:f6:52:0d:0a:5e (try 2/3)
[ 7644.600323] wlan0: direct probe to 90:f6:52:0d:0a:5e (try 3/3)

-Andrew

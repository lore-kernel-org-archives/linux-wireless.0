Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58174 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590Ab2BARE6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 12:04:58 -0500
Message-ID: <4F2970B3.4090203@openwrt.org> (sfid-20120201_180509_591696_5CFE682E)
Date: Wed, 01 Feb 2012 18:04:51 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Mohammed Shafi <shafi.wireless@gmail.com>,
	Laurent Bonnans <bonnans.l@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re:
References: <CAAJ3AHeF5-yD_+a6HiA3Ty-yjizM4hOqS+nnZimbJULuX0s--A@mail.gmail.com> <CAD2nsn2RTzkx_1ApoyPixfim6j5sY7kscW4QAzoVu49HyTNJjA@mail.gmail.com> <CAD2nsn0c=cUdD8kQWNprGr7GJ6t1Y+c=LA2KZ+sSVgrsb3oedQ@mail.gmail.com> <20120201162730.GA29685@tuxdriver.com>
In-Reply-To: <20120201162730.GA29685@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-02-01 5:27 PM, John W. Linville wrote:
> On Wed, Feb 01, 2012 at 04:44:08PM +0530, Mohammed Shafi wrote:
>> On Tue, Jan 31, 2012 at 11:28 AM, Mohammed Shafi
>> <shafi.wireless@gmail.com> wrote:
>> > On Tue, Jan 31, 2012 at 1:13 AM, Laurent Bonnans <bonnans.l@gmail.com> wrote:
>> >> Since the update from linux 3.2.1 to 3.2.2, dhcp stopped working on
>> >> some APs on my laptop with an AR9285 Wireless card.
>> >>
>> >> dhcp works fine on an open wifi network but receives no response on a
>> >> wep network I use. I haven't been able to test it on a third network
>> >> for now.
>> >
>> >  reverting  "ath9k_hw: fix interpretation of the rx KeyMiss flag" does
>> > helps.  i  need to analyze
>> > if it exposes some real issue which need to be fixed.
>> >
>> 
>> this seems to be a problem in WEP alone, where the key miss is always
>> set for this case and RX_FLAG_DECRYPTED is not set. mac80211 trys to
>> decrypt,  but fails due to ICV mismatch.
> 
> OK...any way to differentiate this case at that point in the code?
> 
> John
Please try this patch:

---
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -823,6 +823,15 @@ static bool ath9k_rx_accept(struct ath_c
 		(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_CRC | ATH9K_RXERR_MIC |
 		 ATH9K_RXERR_KEYMISS));
 
+	/*
+	 * First 4 slots are reserved for WEP, and for packets using them,
+	 * ATH9K_RXERR_KEYMISS can be reported even though decryption was
+	 * successful, since no MAC address based key cache lookup was
+	 * performed.
+	 */
+	if (rx_stats->rs_keyix < 4)
+		rx_stats->rs_status &= ~ATH9K_RXERR_KEYMISS;
+
 	if (!rx_stats->rs_datalen)
 		return false;
         /*

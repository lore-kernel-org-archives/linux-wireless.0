Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:46128 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab2DFScn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2012 14:32:43 -0400
Received: by vbbff1 with SMTP id ff1so1337113vbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Apr 2012 11:32:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F7F1780.1090803@openwrt.org>
References: <CAA2SeN+DRnff_e-fDuFAV-vof0OEsw7VEkmxBhUivq0kSspzvw@mail.gmail.com>
	<4F7F1780.1090803@openwrt.org>
Date: Fri, 6 Apr 2012 20:32:42 +0200
Message-ID: <CAA2SeNL0YSiSp4f_jNr8PN5Qo28g2m9aNDRMg45ZyM_wf=vKVA@mail.gmail.com> (sfid-20120406_203247_573445_E409896B)
Subject: Re: [PATCH] ath9k: fix an issue in ieee80211_tx_info count field management
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On 2012-04-05 11:39 PM, Lorenzo Bianconi wrote:
>> Hi all,
>>
>> I noticed a possible issue in the status count field management of the
>> ieee80211_tx_info data structure. In particular, when the AGGR
>> processing is employed,
>> ath_tx_complete_aggr() sets status.rates[].count just for the first
>> frame and not for others belonging to the same burst, leading to wrong
>> statistic data in the mac80211 debug file system.
> The driver behavior is OK and mac80211 needs to be changed. The tx
> status code that counts retries needs to check if AMPDU CTL and STATUS
> flags match and stop counting for packets where they don't match.
>
> - Felix

Ack. I will send another patch in order to fix the issue in mac80211.

Regards

Lorenzo



-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep

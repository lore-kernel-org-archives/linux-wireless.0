Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:46959 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753319AbdJaOyz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Oct 2017 10:54:55 -0400
Subject: Re: [v3] ath10k: rebuild crypto header in rx data frames
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
References: <1509035774-26553-1-git-send-email-kvalo@qca.qualcomm.com>
 <59b2ec22dc9c4db0bd30a65dba660b1c@euamsexm01a.eu.qualcomm.com>
 <154f13b8-1e77-dbe5-4cb0-81c534dbc40b@dd-wrt.com>
Message-ID: <92bd2ece-dd71-b115-22c1-9a105df3612c@dd-wrt.com> (sfid-20171031_155506_789069_AF3667CF)
Date: Tue, 31 Oct 2017 15:54:51 +0100
MIME-Version: 1.0
In-Reply-To: <154f13b8-1e77-dbe5-4cb0-81c534dbc40b@dd-wrt.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

the same is for the MIC

+               /* MIC */
+               if ((status->flag & RX_FLAG_MIC_STRIPPED) &&
+                   enctype == HTT_RX_MPDU_ENCRYPT_AES_CCM_WPA2)
+                       skb_trim(msdu, msdu->len - 8);


this code looks wrong too

Am 30.10.2017 um 10:32 schrieb Sebastian Gottschall:
> will check it tomorrow including gcmp-256, ccmp-256. was out for 
> weekend :-)
>
> Am 30.10.2017 um 09:39 schrieb Kalle Valo:
>> Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>>
>>> Rx data frames notified through HTT_T2H_MSG_TYPE_RX_IND and
>>> HTT_T2H_MSG_TYPE_RX_FRAG_IND expect PN/TSC check to be done
>>> on host (mac80211) rather than firmware. Rebuild cipher header
>>> in every received data frames (that are notified through those
>>> HTT interfaces) from the rx_hdr_status tlv available in the
>>> rx descriptor of the first msdu. Skip setting RX_FLAG_IV_STRIPPED
>>> flag for the packets which requires mac80211 PN/TSC check support
>>> and set appropriate RX_FLAG for stripped crypto tail. Hw QCA988X,
>>> QCA9887, QCA99X0, QCA9984, QCA9888 and QCA4019 currently need the
>>> rebuilding of cipher header to perform PN/TSC check for replay
>>> attack.
>>>
>>> Please note that removing crypto tail for CCMP-256, GCMP and 
>>> GCMP-256 ciphers
>>> in raw mode needs to be fixed. Since Rx with these ciphers in raw
>>> mode does not work in the current form even without this patch and
>>> removing crypto tail for these chipers needs clean up, raw mode related
>>> issues in CCMP-256, GCMP and GCMP-256 can be addressed in follow up
>>> patches.
>>>
>>> Tested-by: Manikanta Pubbisetty <mpubbise@qti.qualcomm.com>
>>> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
>>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>> Patch applied to ath-current branch of ath.git, thanks.
>>
>> 7eccb738fce5 ath10k: rebuild crypto header in rx data frames
>>
>

-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565

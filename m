Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:16185 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751408AbdJaPA1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Oct 2017 11:00:27 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [v3] ath10k: rebuild crypto header in rx data frames
Date: Tue, 31 Oct 2017 15:00:14 +0000
Message-ID: <1509462013076.60330@qti.qualcomm.com> (sfid-20171031_160030_945269_05B0E756)
References: <1509035774-26553-1-git-send-email-kvalo@qca.qualcomm.com>
 <59b2ec22dc9c4db0bd30a65dba660b1c@euamsexm01a.eu.qualcomm.com>
 <154f13b8-1e77-dbe5-4cb0-81c534dbc40b@dd-wrt.com>,<92bd2ece-dd71-b115-22c1-9a105df3612c@dd-wrt.com>
In-Reply-To: <92bd2ece-dd71-b115-22c1-9a105df3612c@dd-wrt.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

=0A=
Sorry top posting.=0A=
=0A=
The issues in raw mode with CCMP-256, GCMP and GCMP-256 were already known =
and=0A=
the same was captured in the commit log. As mentioned in the commit log, ra=
w mode=0A=
with these ciphers does not work even without this particular patch and it =
needs some cleanup=0A=
like done in the follow up patch https://patchwork.kernel.org/patch/1002909=
9/.=0A=
=0A=
Vasanth=0A=
________________________________________=0A=
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>=0A=
Sent: Tuesday, October 31, 2017 8:24 PM=0A=
To: Kalle Valo=0A=
Cc: ath10k@lists.infradead.org; linux-wireless@vger.kernel.org; Vasanthakum=
ar Thiagarajan=0A=
Subject: Re: [v3] ath10k: rebuild crypto header in rx data frames=0A=
=0A=
the same is for the MIC=0A=
=0A=
+               /* MIC */=0A=
+               if ((status->flag & RX_FLAG_MIC_STRIPPED) &&=0A=
+                   enctype =3D=3D HTT_RX_MPDU_ENCRYPT_AES_CCM_WPA2)=0A=
+                       skb_trim(msdu, msdu->len - 8);=0A=
=0A=
=0A=
this code looks wrong too=0A=
=0A=
Am 30.10.2017 um 10:32 schrieb Sebastian Gottschall:=0A=
> will check it tomorrow including gcmp-256, ccmp-256. was out for=0A=
> weekend :-)=0A=
>=0A=
> Am 30.10.2017 um 09:39 schrieb Kalle Valo:=0A=
>> Kalle Valo <kvalo@qca.qualcomm.com> wrote:=0A=
>>=0A=
>>> Rx data frames notified through HTT_T2H_MSG_TYPE_RX_IND and=0A=
>>> HTT_T2H_MSG_TYPE_RX_FRAG_IND expect PN/TSC check to be done=0A=
>>> on host (mac80211) rather than firmware. Rebuild cipher header=0A=
>>> in every received data frames (that are notified through those=0A=
>>> HTT interfaces) from the rx_hdr_status tlv available in the=0A=
>>> rx descriptor of the first msdu. Skip setting RX_FLAG_IV_STRIPPED=0A=
>>> flag for the packets which requires mac80211 PN/TSC check support=0A=
>>> and set appropriate RX_FLAG for stripped crypto tail. Hw QCA988X,=0A=
>>> QCA9887, QCA99X0, QCA9984, QCA9888 and QCA4019 currently need the=0A=
>>> rebuilding of cipher header to perform PN/TSC check for replay=0A=
>>> attack.=0A=
>>>=0A=
>>> Please note that removing crypto tail for CCMP-256, GCMP and=0A=
>>> GCMP-256 ciphers=0A=
>>> in raw mode needs to be fixed. Since Rx with these ciphers in raw=0A=
>>> mode does not work in the current form even without this patch and=0A=
>>> removing crypto tail for these chipers needs clean up, raw mode related=
=0A=
>>> issues in CCMP-256, GCMP and GCMP-256 can be addressed in follow up=0A=
>>> patches.=0A=
>>>=0A=
>>> Tested-by: Manikanta Pubbisetty <mpubbise@qti.qualcomm.com>=0A=
>>> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>=0A=
>>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>=0A=
>> Patch applied to ath-current branch of ath.git, thanks.=0A=
>>=0A=
>> 7eccb738fce5 ath10k: rebuild crypto header in rx data frames=0A=
>>=0A=
>=0A=
=0A=
--=0A=
Mit freundlichen Gr=FCssen / Regards=0A=
=0A=
Sebastian Gottschall / CTO=0A=
=0A=
NewMedia-NET GmbH - DD-WRT=0A=
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim=0A=
Registergericht: Amtsgericht Darmstadt, HRB 25473=0A=
Gesch=E4ftsf=FChrer: Peter Steinh=E4user, Christian Scheele=0A=
http://www.dd-wrt.com=0A=
email: s.gottschall@dd-wrt.com=0A=
Tel.: +496251-582650 / Fax: +496251-5826565=0A=
=0A=

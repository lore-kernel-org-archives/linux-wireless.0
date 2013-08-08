Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:54747 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934106Ab3HHJNB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Aug 2013 05:13:01 -0400
Received: by mail-bk0-f50.google.com with SMTP id mz11so578426bkb.23
        for <linux-wireless@vger.kernel.org>; Thu, 08 Aug 2013 02:12:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87eha4363n.fsf@kamboji.qca.qualcomm.com>
References: <1375949298-7159-1-git-send-email-michal.kazior@tieto.com>
	<1375949298-7159-4-git-send-email-michal.kazior@tieto.com>
	<87eha4363n.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 8 Aug 2013 11:12:58 +0200
Message-ID: <CA+BoTQnoVmQcMnajTx3vsKwct5PLCNOt6w2qo17fyigm=gO5-w@mail.gmail.com> (sfid-20130808_111306_181776_B347026A)
Subject: Re: [RFC 3/3] ath10k: add support for HTT 3.0
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 August 2013 11:05, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> New firmware comes with new HTT protocol version.
>> In 3.0 the separate mgmt tx command has been
>> removed. All traffic is to be pushed through data
>> tx (tx_frm) command with a twist - FW seems to not
>> be able (yet?) to access tx fragment table so for
>> manamgement frames frame pointer is passed
>> directly.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> [...]
>
>>  static int ath10k_htt_verify_version(struct ath10k_htt *htt)
>>  {
>> -     ath10k_dbg(ATH10K_DBG_HTT,
>> -                "htt target version %d.%d; host version %d.%d\n",
>> -                 htt->target_version_major,
>> -                 htt->target_version_minor,
>> -                 HTT_CURRENT_VERSION_MAJOR,
>> -                 HTT_CURRENT_VERSION_MINOR);
>> -
>> -     if (htt->target_version_major != HTT_CURRENT_VERSION_MAJOR) {
>> +     ath10k_dbg(ATH10K_DBG_HTT, "htt target version %d.%d\n",
>> +                htt->target_version_major, htt->target_version_minor);
>
> This debug print is good to have, but with the new htt version it would
> be good to print it always using the info level. For example, can we add
> it to the same line with "firmware %s booted" string?

HTT target version is not known when firmware boots up. It's not known
until everything other (HTC, WMI) is set up. We then send a version
request command and we get a response.

We need to print it in a separate line.


> (Please take into account that the info messages still need to be
> compact, by default they should not be longer than five lines or so.)
>
>> +     if (htt->target_version_major != 2 &&
>> +         htt->target_version_major != 3) {
>>               ath10k_err("htt major versions are incompatible!\n");
>>               return -ENOTSUPP;
>>       }
>
> Print the htt version in the error message as well?

Target version is printed in ath10k_dbg() now. If we change that to
ath10k_info() I don't see any reason to print the version again on
error. We may want to print the list of supported HTT major version
numbers though?


>> @@ -401,10 +401,15 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
>>               goto err;
>>       }
>>
>> -     txfrag = dev_alloc_skb(frag_len);
>> -     if (!txfrag) {
>> -             res = -ENOMEM;
>> -             goto err;
>> +     /* Since HTT 3.0 there is no separate mgmt tx command. However in case
>> +      * of mgmt tx using TX_FRM there is not tx fragment list. Instead of tx
>> +      * fragment list host driver specifies directly frame pointer. */
>> +     if (!(htt->target_version_major >= 3 && ieee80211_is_mgmt(hdr->frame_control))) {
>
> I think using "< 3" is more readable:
>
> if (htt->target_version_major < 3 &&
>    !ieee80211_is_mgmt(hdr->frame_control)) {
>         ...
> }

I don't have a problem with changing that.


> And is the single line too long? Didn't count it, though.

Ah, I didn't check that. Sorry. Good catch.



Pozdrawiam / Best regards,
Michał Kazior.

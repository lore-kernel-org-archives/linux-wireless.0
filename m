Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:32868 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751129AbcISJW1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 05:22:27 -0400
Received: by mail-lf0-f53.google.com with SMTP id h127so105931155lfh.0
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2016 02:22:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57DC735D.8020307@qca.qualcomm.com>
References: <1468924452-23877-1-git-send-email-michal.kazior@tieto.com>
 <1468924452-23877-5-git-send-email-michal.kazior@tieto.com> <57DC735D.8020307@qca.qualcomm.com>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Mon, 19 Sep 2016 11:22:25 +0200
Message-ID: <CA+BoTQ=mfYYQ8RfygF-QpWX3Tz7b1e2d0vVFzi_P4_BYd8EcAA@mail.gmail.com> (sfid-20160919_112235_850454_002FCCD6)
Subject: Re: [PATCH 4/4] ath10k: fix spurious tx/rx during boot
To: "Hsu, Ryan" <ryanhsu@qca.qualcomm.com>
Cc: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
        "marek.puzyniak@tieto.com" <marek.puzyniak@tieto.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 September 2016 at 00:37, Hsu, Ryan <ryanhsu@qca.qualcomm.com> wrote:
[...]
>> +     /* WMI and HTT may use separate HIF pipes and are not guaranteed to be
>> +      * serialized properly implicitly.
>> +      *
>> +      * Moreover (most) WMI commands have no explicit acknowledges. It is
>> +      * possible to infer it implicitly by poking firmware with echo
>> +      * command - getting a reply means all preceding comments have been
>> +      * (mostly) processed.
>> +      *
>> +      * In case of vdev create/delete this is sufficient.
>> +      *
>> +      * Without this it's possible to end up with a race when HTT Rx ring is
>> +      * started before vdev create/delete hack is complete allowing a short
>> +      * window of opportunity to receive (and Tx ACK) a bunch of frames.
>> +      */
>> +     ret = ath10k_wmi_barrier(ar);
> QCA6174 UTF firmware seems doesn't support the WMI_ECHO command.
>
> [16460.274822] ath10k_pci 0000:04:00.0: wmi tlv echo value 0x0ba991e9
> ...
> [16463.461970] ath10k_pci 0000:04:00.0: failed to ping firmware: -110
> [16463.461975] ath10k_pci 0000:04:00.0: failed to reset rx filter: -110
>
> Has anyone verified any AP solution to see if UTF mode is still working
> with after this patch?
>
> Anyway, I would like to exclude the workaround from all solution's UTF mode.
>
> Michal any concerns? (or maybe just for QCA61x4 if any...)

I didn't expect UTF wouldn't support echo.. Sorry!

If you skip this workaround for UTF I guess the device will (again) be
able to generate some bogus traffic on boot for UTF case. Not sure how
much of a problem that is (assuming it is at all).


Michal

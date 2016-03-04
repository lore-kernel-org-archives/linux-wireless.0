Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:33757 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758743AbcCDUCh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2016 15:02:37 -0500
Received: by mail-yk0-f179.google.com with SMTP id z13so27454854ykd.0
        for <linux-wireless@vger.kernel.org>; Fri, 04 Mar 2016 12:02:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87a8mexpqb.fsf@kamboji.qca.qualcomm.com>
References: <1455704830-10088-1-git-send-email-arend@broadcom.com>
	<1455704830-10088-19-git-send-email-arend@broadcom.com>
	<87a8mexpqb.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 4 Mar 2016 21:02:36 +0100
Message-ID: <CAF7Mx6p4NVe-fBpLbb75ywtNNBWaheD6ciZQVUBUc+iiUgKKDw@mail.gmail.com> (sfid-20160304_210240_649522_9683FFA4)
Subject: Re: [PATCH 18/21] brcmfmac: switch to new platform data
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 4, 2016 at 3:49 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
[...]
>> +struct brcmfmac_platform_data {
>> +     void    (*power_on)(void);
>> +     void    (*power_off)(void);
>> +     char    *fw_alternative_path;
>> +     int     device_count;
>> +     struct brcmfmac_pd_device devices[0];
>> +};
>
> If I understood correctly this undocumented, and not mentioned in the
> commit log, fw_alternative_path is a new feature in platform data. I
> guess it provides a different firmware image name for the device so that
> devices can have different firmware images on the same system?

Actually, fw_alternative_path was a module parameter, but now it can
also be specified in platform_data. It causes the firmware names in
request_firmware api to be absolute paths thus overriding the path
prefixes tried in firmware_class.

> It's not pretty but I guess okayish. Opinions?
>
> --
> Kalle Valo

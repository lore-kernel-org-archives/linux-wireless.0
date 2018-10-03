Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FECEC64EBC
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 09:58:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E949B2098A
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 09:58:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IRAPLirT";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IRAPLirT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E949B2098A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbeJCQpn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 12:45:43 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59360 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725746AbeJCQpn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 12:45:43 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 668E96079C; Wed,  3 Oct 2018 09:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538560682;
        bh=9tBJ1/LvggrCHA/EPLB6ubAGRzeC9XUtM9E9G40VkFA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=IRAPLirTdKo0HsKJQ7gk5OKWQzmGCl/8fhF7gx6ABYZRurjyO8HrX044Ua6FjxRe6
         a/GML/jG4jrDw89n412Y3Corl8n2h3n9tPMLlHbNpW6vV1Qx5sE5UX2Ix/eIn2zwAx
         tIXlvdknln9w3duXIPVkRszruH8HsxJOq/w/aQGg=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B326860275;
        Wed,  3 Oct 2018 09:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538560682;
        bh=9tBJ1/LvggrCHA/EPLB6ubAGRzeC9XUtM9E9G40VkFA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=IRAPLirTdKo0HsKJQ7gk5OKWQzmGCl/8fhF7gx6ABYZRurjyO8HrX044Ua6FjxRe6
         a/GML/jG4jrDw89n412Y3Corl8n2h3n9tPMLlHbNpW6vV1Qx5sE5UX2Ix/eIn2zwAx
         tIXlvdknln9w3duXIPVkRszruH8HsxJOq/w/aQGg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B326860275
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>
Cc:     Kai Heng Feng <kai.heng.feng@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Berg\, Johannes" <johannes.berg@intel.com>,
        "Coelho\, Luciano" <luciano.coelho@intel.com>,
        linuxwifi <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: Re: [RESEND] [PATCH 3/3] iwlwifi: Load firmware exclusively for Intel WiFi
References: <20181003073556.28154-1-kai.heng.feng@canonical.com>
        <20181003073556.28154-3-kai.heng.feng@canonical.com>
        <87y3bfiees.fsf@kamboji.qca.qualcomm.com>
        <265BAF93-4BFF-4850-92F7-80AC39496473@canonical.com>
        <0BA3FCBA62E2DC44AF3030971E174FB301336D868D@HASMSX111.ger.corp.intel.com>
Date:   Wed, 03 Oct 2018 12:57:57 +0300
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB301336D868D@HASMSX111.ger.corp.intel.com>
        (Emmanuel Grumbach's message of "Wed, 3 Oct 2018 09:50:58 +0000")
Message-ID: <871s97ic7u.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ linux-bluetooth

"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:

>>=20
>> > On Oct 3, 2018, at 5:10 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>> >
>> > Kai-Heng Feng <kai.heng.feng@canonical.com> writes:
>> >
>> >> To avoid the firmware loading race between Bluetooth and WiFi on
>> >> Intel 8260, load firmware exclusively when BT_INTEL is enabled.
>> >>
>> >> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>> >
>> > Still the commit log tells nothing about the actual problem which
>> > makes review impossible.
>>=20
>> Sorry for that. The first two patches [1] only sends to linux-bluetooth =
and
>> LMKL.
>>=20
>> I don=E2=80=99t know what really happened at hardware/firmware level, bu=
t making
>> btusb and iwlwifi load firmware sequentially can workaround the issue.
>>=20
>> Matt Chen may be able to explain this issue with more detail.
>>=20
>> [1] https://lkml.org/lkml/2018/10/3/322
>>
>
> I just read the code of this patch and I don't quite understand.
> You have a function that is declared as a non-inline function in two diff=
erent header files?
> btintel_firmware_lock is declared here:
>
> --- /dev/null
> +++ b/include/linux/intel-wifi-bt.h
> @@ -0,0 +1,8 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __INTEL_WIFI_BT_H__
> +#define __INTEL_WIFI_BT_H__
> +
> +void btintel_firmware_lock(void);
>
> And ...
>
> diff --git a/drivers/bluetooth/btintel.h b/drivers/bluetooth/btintel.h
> index 41c642cc523f..1373ffc2b575 100644
> --- a/drivers/bluetooth/btintel.h
> +++ b/drivers/bluetooth/btintel.h
> @@ -102,6 +102,8 @@ int btintel_read_boot_params(struct hci_dev *hdev,
>  			     struct intel_boot_params *params);
>  int btintel_download_firmware(struct hci_dev *dev, const struct firmware=
 *fw,
>  			      u32 *boot_param);
> +void btintel_firmware_lock(void);
>
>
> This can't be right.

--=20
Kalle Valo

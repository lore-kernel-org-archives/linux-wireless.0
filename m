Return-Path: <SRS0=smuk=M7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A7C0ECDE3D
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 09:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4EB320869
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 09:15:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="DnzReWTB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C4EB320869
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbeJSRUq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 19 Oct 2018 13:20:46 -0400
Received: from nbd.name ([46.4.11.11]:47456 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726399AbeJSRUp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Oct 2018 13:20:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Ui1ven1TYTYtJTHG3K/z2WB1JybgnU+3gGi6b2i1Y4c=; b=DnzReWTBYY1MMNsKP+0f1VkrpT
        SJ/Tdl13oS59+n2rHHT00vKqyGmecuevrAf3J4fzWHQ19QcKnvMDb8S7VqxSrVId+C5GNLDMxKPMT
        agbELr+trSA/AH5mdAmCmP9xZ2NNT6CIXWLsV6gqN69ZVjyX8Qo33vMdDXiAhXzJKsIY=;
Subject: Re: [PATCH] mt76x0: align mt76x0u and mt76x0e fw version
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
References: <cover.1539938482.git.lorenzo.bianconi@redhat.com>
 <bd30d8b3853395565d5e81acb98ae3d43ddc1f6e.1539938482.git.lorenzo.bianconi@redhat.com>
From:   Felix Fietkau <nbd@nbd.name>
Openpgp: preference=signencrypt
Autocrypt: addr=nbd@nbd.name; prefer-encrypt=mutual; keydata=
 xsDiBEah5CcRBADIY7pu4LIv3jBlyQ/2u87iIZGe6f0f8pyB4UjzfJNXhJb8JylYYRzIOSxh
 ExKsdLCnJqsG1PY1mqTtoG8sONpwsHr2oJ4itjcGHfn5NJSUGTbtbbxLro13tHkGFCoCr4Z5
 Pv+XRgiANSpYlIigiMbOkide6wbggQK32tC20QxUIwCg4k6dtV/4kwEeiOUfErq00TVqIiEE
 AKcUi4taOuh/PQWx/Ujjl/P1LfJXqLKRPa8PwD4j2yjoc9l+7LptSxJThL9KSu6gtXQjcoR2
 vCK0OeYJhgO4kYMI78h1TSaxmtImEAnjFPYJYVsxrhay92jisYc7z5R/76AaELfF6RCjjGeP
 wdalulG+erWju710Bif7E1yjYVWeA/9Wd1lsOmx6uwwYgNqoFtcAunDaMKi9xVQW18FsUusM
 TdRvTZLBpoUAy+MajAL+R73TwLq3LnKpIcCwftyQXK5pEDKq57OhxJVv1Q8XkA9Dn1SBOjNB
 l25vJDFAT9ntp9THeDD2fv15yk4EKpWhu4H00/YX8KkhFsrtUs69+vZQwc0cRmVsaXggRmll
 dGthdSA8bmJkQG5iZC5uYW1lPsJgBBMRAgAgBQJGoeQnAhsjBgsJCAcDAgQVAggDBBYCAwEC
 HgECF4AACgkQ130UHQKnbvXsvgCgjsAIIOsY7xZ8VcSm7NABpi91yTMAniMMmH7FRenEAYMa
 VrwYTIThkTlQzsFNBEah5FQQCACMIep/hTzgPZ9HbCTKm9xN4bZX0JjrqjFem1Nxf3MBM5vN
 CYGBn8F4sGIzPmLhl4xFeq3k5irVg/YvxSDbQN6NJv8o+tP6zsMeWX2JjtV0P4aDIN1pK2/w
 VxcicArw0VYdv2ZCarccFBgH2a6GjswqlCqVM3gNIMI8ikzenKcso8YErGGiKYeMEZLwHaxE
 Y7mTPuOTrWL8uWWRL5mVjhZEVvDez6em/OYvzBwbkhImrryF29e3Po2cfY2n7EKjjr3/141K
 DHBBdgXlPNfDwROnA5ugjjEBjwkwBQqPpDA7AYPvpHh5vLbZnVGu5CwG7NAsrb2isRmjYoqk
 wu++3117AAMFB/9S0Sj7qFFQcD4laADVsabTpNNpaV4wAgVTRHKV/kC9luItzwDnUcsZUPdQ
 f3MueRJ3jIHU0UmRBG3uQftqbZJj3ikhnfvyLmkCNe+/hXhPu9sGvXyi2D4vszICvc1KL4RD
 aLSrOsROx22eZ26KqcW4ny7+va2FnvjsZgI8h4sDmaLzKczVRIiLITiMpLFEU/VoSv0m1F4B
 FtRgoiyjFzigWG0MsTdAN6FJzGh4mWWGIlE7o5JraNhnTd+yTUIPtw3ym6l8P+gbvfoZida0
 TspgwBWLnXQvP5EDvlZnNaKa/3oBes6z0QdaSOwZCRA3QSLHBwtgUsrT6RxRSweLrcabwkkE
 GBECAAkFAkah5FQCGwwACgkQ130UHQKnbvW2GgCfTKx80VvCR/PvsUlrvdOLsIgeRGAAn1ee
 RjMaxwtSdaCKMw3j33ZbsWS4
Message-ID: <4d7f5be8-9413-b93d-f54f-5d6a10e293d6@nbd.name>
Date:   Fri, 19 Oct 2018 11:15:30 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <bd30d8b3853395565d5e81acb98ae3d43ddc1f6e.1539938482.git.lorenzo.bianconi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-10-19 10:58, Lorenzo Bianconi wrote:
> Unify firmware version used on mt76x0e and mt76x0u drivers.
> Fallback to mt7610u fw if mt7610e one is not available
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> ---
> this patch is based on top of:
> https://patchwork.kernel.org/patch/10648399/
> ---
>  .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  2 ++
>  .../net/wireless/mediatek/mt76/mt76x0/usb.c   |  2 ++
>  .../wireless/mediatek/mt76/mt76x0/usb_mcu.c   | 23 +++++++++++++++----
>  3 files changed, 23 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c
> index a9f14d5149d1..b57c2a11146f 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c
> @@ -22,7 +22,6 @@
>  
>  #define MCU_FW_URB_MAX_PAYLOAD		0x38f8
>  #define MCU_FW_URB_SIZE			(MCU_FW_URB_MAX_PAYLOAD + 12)
> -#define MT7610U_FIRMWARE		"mediatek/mt7610u.bin"
>  
>  static int
>  mt76x0u_upload_firmware(struct mt76x02_dev *dev,
> @@ -75,6 +74,24 @@ mt76x0u_upload_firmware(struct mt76x02_dev *dev,
>  	return err;
>  }
>  
> +static int mt76x0_get_firmware(struct mt76x02_dev *dev,
> +			       const struct firmware **fw)
> +{
> +	int err;
> +
> +	/* try to load mt7610e fw if available
> +	 * otherwise fall back to mt7610u one
> +	 */
> +	err = request_firmware(fw, MT7610E_FIRMWARE, dev->mt76.dev);
> +	if (err) {
> +		dev_info(dev->mt76.dev, "%s not found, switching to %s",
> +			 MT7610E_FIRMWARE, MT7610U_FIRMWARE);
> +		return request_firmware(fw, MT7610U_FIRMWARE,
> +					dev->mt76.dev);
> +	}
> +	return 0;
> +}
You should use firmware_request_nowarn for the first request.

- Felix

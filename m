Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1092D35677D
	for <linux-wireless@vger.kernel.org>; Sun,  6 Sep 2026 20:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788727454; cv=none; b=I4cyAyX90E9hd9cKR2WScUdJaXIoHASYsNkRav8etVUXmx/a6SWsFHCXsw4KCC1Brr1+UEcgvKVnrlr/Vrym/eQj3A3vA3hPJfVAaxGXZxVrpqYsuE91HbprNBnuE5OBLbpZFVM4rZ1XdM8I0383kQbOXfntSav+cSKyKruN0jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788727454; c=relaxed/simple;
	bh=gX4QggEryg1cIxN5EI0dbWpi4QT15DyTubvIPqUvmf8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=t+m8IxgTun3VgUFq6uO9MM8+TR7uDcUh25fPA6DbFXVUfHrGnjluKyLNltdgqwj51ewIYz/h/LW3BLrPTyD0sQV02BC6FTRtGHJ5ud1e71IqUwi+Wyl0bG/LgLKkm//VxDJwWQlxQFzXJcSTdR9Og0/btrkWPIpxGWRFS5xhgCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q0I6V7F9; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q0I6V7F9"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-499b2981a7bso29892255e9.3
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2026 13:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788727451; x=1789332251; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YPj6QUYKEgOwyCjwO8AZVvBEPqAex2m6goITgNkt8RU=;
        b=Q0I6V7F9nAT6FJqJdAKgm8E62j4nMrb21k0CBa9DHYp1USA1h3CsHNJ0yKjky7SFtT
         eumovkGZHCYEWcu3GAoKB9kfXJGBOx2jV7FkaM8Uh1thyaq3hEBC9YityJeJ2duGzW0X
         vVl4nPVt3D1fGk1PDfNJipZ4cjiP/6bA1ulLrbCKfaQj+xN/y0wZdpSUSTJUQEQ+kRn+
         lrakLWs97PCBnKHCNVZc2QWRZXgcn46xqm+E57waOLo2YCzKDhI1GAjS3YF0n/noY6Eu
         8ml4yZ5AP3Evjt3QSlPLAVO9YjJvBf5/c6rBT6E1JcKIV+UwUDngorkhVbWT7ZtqpLJz
         FaYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788727451; x=1789332251;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YPj6QUYKEgOwyCjwO8AZVvBEPqAex2m6goITgNkt8RU=;
        b=Q/4MHfUG7xjZteib/3gdsgkLMqfSfqc8gHKYK2XVFiwux/hRDJKmMGPiMx2exJaHGf
         vNqVeRyGkRQFxtZXDr+zYarL4V0WxFiVkVtOygi2tmJrwwdnEvaHB9z5TXmoYyRR44Xq
         NrtfuZVHnSAC0AWGgivgXG/SxPuLfyzTt3y59kD+K2o1Xz6DjDQUVdIbpyACmK3na4kd
         UxTiiHztol9J4GqDMcI8RGOISs+VUUwzmgkb7z9GocFGKpV3ARWLuUSpQgK18glHeIB9
         FsxulDiviGmCnt8p0OUIyCK3FqR76fcJcNKG3S7fUCAsx1kB0Y9U9DAoyFOgRYmiF1R0
         cgVw==
X-Forwarded-Encrypted: i=1; AKwUvBz+6e/yb1+YVv95lAPOR46GiC67bFyVwMYTeGB+Ytz07OgNEKoxoxp3/lZbHRwZeksPYq/OfSef6p0+gbZysg==@vger.kernel.org
X-Gm-Message-State: AFuF++kN5K6sjc7uU1Rt/fBLKcjjusFif0ALCSKAbq1bJWNcfMvwwDHR
	MtDdxFTrZ/MdTjSY7P5b+5vkpd49Dkhp4NNJ27YhBWbWU7nfK171PYrU
X-Gm-Gg: AYBFou1/UliiFWP9/v6HUQHmbqtmT5nJnpplQi7jYJUEvcm7KpWx48aNMHsKYKtYNct
	11W2pnCwTiu8Jrl/purLoZAlsMMxC8q7PiK+eSDJPixaF6K/+1hkyQrzcwi6JVTQ85Qn38Px4oT
	bBL0zeOT3pg6duC86LMK4dpO/KzLlODmCtQCHbu6xhaZwrGtzn5GpiZ+nNq4IhtmBFk3j8VOwZS
	YRdIiiceXYDYcpgpMSC/0BPUpRJMglEXCKOvgVjFdCw1LcqkEJBKIVJPczqXJuRTLbncjtiTkAc
	xGOEWmTJi9h9w0r6L0jnZtDdezaFC7LKpUPcm9++2O3VBuJnBPuSROg1nU7tnOq6hIpbzGIulJX
	USyy+Pj/yYATfOu+ppAfGPS9nsADJSFkDRyQ0wdClP6XEc2quq3C0CO3Wm45miRkZ1vBXBCO3jB
	/wtT2LuRa6Bi7f/IEinwbnOgKDIFr6PVWDxumm68LaQ5Oqmm9HlpoIb4fT5TB7lD3mAA==
X-Received: by 2002:a05:600c:6087:b0:49c:d52e:d0ea with SMTP id 5b1f17b1804b1-49cf81e3454mr397273975e9.4.1788727451075;
        Sun, 06 Sep 2026 13:44:11 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cf75cd8d0sm238044635e9.2.2026.09.06.13.44.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Sep 2026 13:44:10 -0700 (PDT)
Message-ID: <e864365d-c9c5-4609-94b7-4ec4e3754136@gmail.com>
Date: Sun, 6 Sep 2026 23:44:08 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next] wifi: mt7601u: add vnd_reset parameter to
 fix probe failure on Tenda U2
To: Herman Semenoff <germanaizek0@gmail.com>, kuba@kernel.org,
 kvalo@kernel.org, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <CAMnMt5aJwVXEVKyBR7MvVBd=qCn7fNijMC+O_cZn82zGuNPc3A@mail.gmail.com>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <CAMnMt5aJwVXEVKyBR7MvVBd=qCn7fNijMC+O_cZn82zGuNPc3A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 06/09/2026 23:20, Herman Semenoff wrote:
> From c03d73d37df440d0046d68406fde2aa1f62fe0d1 Mon Sep 17 00:00:00 2001
> From: Herman Semenoff <GermanAizek@aizekgroup.ru>
> Date: Thu, 3 Sep 2026 07:14:32 +0300
> Subject: [PATCH wireless-next] wifi: mt7601u: add vnd_reset parameter
> to fix probe failure on Tenda U2
> 
> On certain MT7601U adapters, such as Tenda U2 and other newer hardware
> revisions, driver initialization consistently fails during probe with
> vendor request timeouts (-110 / -ETIMEDOUT):
> 
>     mt7601u 3-14:1.0: ASIC revision: 76010001 MAC revision: 76010500
>     mt7601u 3-14:1.0: Firmware Version: 0.1.00 Build: 7640
>     mt7601u 3-14:1.0: Vendor request req:07 off:09a8 failed:-110
>     mt7601u 3-14:1.0: Vendor request req:02 off:09a8 failed:-110
>     mt7601u 3-14:1.0: Vendor request req:07 off:0734 failed:-110
>     mt7601u 3-14:1.0: Vendor request req:42 off:0230 failed:-110
>     mt7601u 3-14:1.0: probe with driver mt7601u failed with error -110
> 
> The failure occurs because mt7601u_load_firmware() unconditionally calls
> mt7601u_vendor_reset() (MT_VEND_DEV_MODE_RESET) before uploading firmware
> chunks. On these devices, issuing this vendor reset leaves the internal
> MCU / FCE DMA engine in an unresponsive state after the first firmware
> URB is submitted. As a result, reading MT_TX_CPU_FROM_FCE_CPU_DESC_IDX
> (0x09a8) immediately times out.
> 
> Introduce a boolean module parameter 'vnd_reset' (default: false) to
> make this vendor reset optional. When the vendor reset is skipped,
> firmware upload succeeds and the wireless interface initializes normally.
> 

Hi,

I don't think a new module parameter will be accepted.

You could just delete the vendor reset. The devices which currently work
with the vendor reset will probably still work without it:

https://lore.kernel.org/linux-wireless/62826d1d-9cef-4eff-b6c5-5ed11405a482@gmail.com/

> Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1716301
> Link: https://www.opena.tv/viewtopic.php?t=63919
> Link: https://askubuntu.com/questions/1418850/the-problem-with-wi-fi-u2
> Link: https://bbs.archlinux.org/viewtopic.php?id=224859
> Link: https://reddit.com/r/archlinux/comments/1d6dfv5/mt7601u_usb_wifi_not_working/
> Signed-off-by: Herman Semenoff <GermanAizek@aizekgroup.ru>
> ---
> This patch is based on linux-next (tag: next-20260904, commit af5f12805e5c)
> and targets the wireless-next tree.
> 
> Note: Alternatively, if maintainers prefer to avoid adding a module
> parameter and can confirm that mt7601u_vendor_reset() is not required
> on any supported hardware, the vendor reset call could instead be dropped
> entirely.
> 
>  drivers/net/wireless/mediatek/mt7601u/mcu.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt7601u/mcu.c
> b/drivers/net/wireless/mediatek/mt7601u/mcu.c
> index bad6ca821400..c7c5bd9bb9df 100644
> --- a/drivers/net/wireless/mediatek/mt7601u/mcu.c
> +++ b/drivers/net/wireless/mediatek/mt7601u/mcu.c
> @@ -10,6 +10,7 @@
>  #include <linux/delay.h>
>  #include <linux/usb.h>
>  #include <linux/skbuff.h>
> +#include <linux/moduleparam.h>
> 
>  #include "mt7601u.h"
>  #include "dma.h"
> @@ -21,6 +22,10 @@
>  #define MCU_FW_URB_SIZE (MCU_FW_URB_MAX_PAYLOAD + 12)
>  #define MCU_RESP_URB_SIZE 1024
> 
> +static bool vnd_reset;
> +module_param(vnd_reset, bool, 0644);
> +MODULE_PARM_DESC(vnd_reset, "Perform vendor reset during firmware
> upload (default: false)");
> +
>  static inline int firmware_running(struct mt7601u_dev *dev)
>  {
>   return mt7601u_rr(dev, MT_MCU_COM_REG0) == 1;
> @@ -459,8 +464,10 @@ static int mt7601u_load_firmware(struct mt7601u_dev *dev)
>   mt7601u_wr(dev, 0x94c, 0);
>   mt7601u_wr(dev, MT_FCE_PSE_CTRL, 0);
> 
> - mt7601u_vendor_reset(dev);
> - msleep(5);
> + if (vnd_reset) {
> + mt7601u_vendor_reset(dev);
> + usleep_range(5000, 10000);
> + }
> 
>   mt7601u_wr(dev, 0xa44, 0);
>   mt7601u_wr(dev, 0x230, 0x84210);


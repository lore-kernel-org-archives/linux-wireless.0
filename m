Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792514146;
	b=VEPOguiTKJxmIelaAyw5oLZASRSSr3JOjRjllJmZuA0LQIeOAYnNNE972gjXqA9+S13g
	 dJcLGHxc8J4Qi/GdnMrOQ/kOd26i9TqTJTYQhsL1vZBm7ctVZRsCzpbYryrcbpqL8wGoh
	 yHNyUpnkB+rDV+cYSPbL8AH5Fz5zf0VFlIFgGEz2Z6ZBhUKPVl9ob/rgvd2bM3cj9E3Qd
	 SnXYOeoAboiZJ2AS5j1XgtvBq7UpSlfv3KZUwZVyOB1+tJn0tlr7bBs7EDmy/DYbB6Jl3
	 bTWrJkr2fYZMAKZFr3n4GeMJTpFlXtYTI+CVXMPl9fpOEuSeB4sMcaUfBAYoGl8nVhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792514146;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=1WUy5/o3M0me+0PHeE9GQgXuk3TppngjPaQFtJw/+mE=;
	b=14gMvT+gURc1WbFBB2TSsvx0Ia21cH/AVQzW2aM8NVdrchSJzeqWGOLFhhH+gRwbe9EX
	 mcSrJCZjG97uXlawq2zUlUV+3RmMVxtQQqXFMao5MKyxI+DAw9EJem6BR29BGsDz0NScH
	 NSr9HNzZHJYdT3Kcyr7fdFh6SACePWfEw/PxM1rZwT90sFSquIjNZi9B3k2KO4vTE2Z6g
	 hMTnJNmFWVIWu/QSY36KtgWne4GbVGw1hyv75yZSQBwWJyGEDUIR5trT07aHvSSubq4zv
	 idtkTGJK0KUWIIEO6KSEpDOtmlm1YifVfayxAdUcEbXNCWfc+n7rkvqCVbzYK3AIoRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Yowd+VS9;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C66606A31D
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 16:35:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6C66606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Yowd+VS9
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a1d75f2f11so24062425e9.3
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 09:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792514144; x=1793118944; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1WUy5/o3M0me+0PHeE9GQgXuk3TppngjPaQFtJw/+mE=;
        b=Yowd+VS9UebTGbRMDgGjyduXIKNl4fS7wxLxtUQmLsedmjNzi8V6okAZBdlegqHpTe
         Plzp1s4Wr+qKUJSvkHRQdTcRJyTS9WRhJzi/H6/5tR7UzJM2zEgflD70iHWl52LBKNF4
         QJOh0jJEwijAbK3grDWB1XTi1/u0IfvAP11SJyTW8SNL27veDsPLQjhGV6rxINR7ow6o
         Axu5PuB7fa+nATNYcta7y1AI+V0o//Z8Rxj0+m/7N27F3yr7rYaPaJjM6/6qfU6BxR+5
         A7eRG4mF54I82PTpC/AG4kb5SKSwLrtYjI8ipyVpRBSkfym4R86NnjTqK4LoWU3Seort
         jSOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792514144; x=1793118944;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1WUy5/o3M0me+0PHeE9GQgXuk3TppngjPaQFtJw/+mE=;
        b=DC8x/GYMNufvMhxIhTL8GIgKw0p0yERjDK5GnkpHqFS313eF2XLJMfnfL38Mm8DXIo
         087tkehXcZ/wCQrr6aWNbrsjiKMEQaHuDJmew49JdAKROSFgM7dAl3CdfQL0AcHjv8f5
         eYjn3shkcQxiLK3gNoTaoYNHOhxpLkZtGvqBnmTiqk8H+8RpsK8+DaFyHgKejaVUqmOK
         fNZ6JzpId8iiUMEAbVbc0vRVAHBK3cMZhNId2xir4yaZM9TVxe8ywjVmvji8A99tlfy/
         zz3rXeoXFskuvN52JdhQMCQ9OkWRZxU//xsCrYOvHZQLBZ1jw+K7S66VncSLp1zuigvf
         +arg==
X-Forwarded-Encrypted: i=1; AKwUvBzxq/HjdWC1n7BY6Rw0LuevbKM53rMltBqIk4H9VWPhI8eAYNOCC45UgneNUkZ+8wZu33XXjU9UZnotQQYWVg==@vger.kernel.org
X-Gm-Message-State: AFq9FYK5N9vwwJyMH3KPYbLWg//leROcMWOD+ViAD67Y30HZzUwa4snC
	87U1K3d7DbefKLpq+xyJ1G4NDWaGXHYO413EXM7n+vfNht5DOl45e0To
X-Gm-Gg: AYBFou2UQWmJj/IMtelwC9Hyfo72c+FhOiwpDpJ2+cPPp1TVnxV6F6j3WukD/tYGPJ0
	K6ZKwAWe/UuDl5SD7S9JTKGHTy/usMct65WCEuvkD3KZZ3uQ6eYCeX7xanksZoPYfTntvE+Rd4g
	/iAanIaq4i2gLbWhq7jETY7wMDRwYBtDGIwZmupkIjg1OlER9rxo+OAyRCoJYhyQE1X4RG57Ufo
	qf1UJgTY4cTsuHbdVbFn2165q8kvrqVAigRU29845doffTVWH131k6WlvTyZSHovf1QjEfMCeBT
	yWP2SqQ0Q99tzJonOERaEVnjxaT555Xo/KeOtpKZuKxiRVfNlEAfziZbvuzsjZlci+8r4MoCheo
	0b61IIU3yXCGPgXLA2FFP7r1ykOzaXM4hwEDTYVBeQQaOGwQMKcthmobTnbkzmnoBrmUrSyEG7R
	p9T1wGdiUUcYuPfcsQjPy7ufDrNkCEdB653oQlEQLZVPtfjvzk9VdQF1FBqT0fHcXPIANaGnjhM
	pjXAA==
X-Received: by 2002:a05:600c:3f0c:b0:4a1:e383:6811 with SMTP id 5b1f17b1804b1-4a1e3836c4amr166413515e9.29.1792514144048;
        Tue, 20 Oct 2026 09:35:44 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1fb859326sm8859885e9.10.2026.10.20.09.35.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2026 09:35:43 -0700 (PDT)
Message-ID: <8e7ecf8e-5757-4162-bc23-e22d0623ec76@gmail.com>
Date: Tue, 20 Oct 2026 19:35:41 +0300
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rtw-next] wifi: rtw88: 8723b: Read the package type from
 efuse
To: Luka Gejak <luka.gejak@linux.dev>, Ping-Ke Shih <pkshih@realtek.com>,
 linux-wireless@vger.kernel.org
References: <d22c9202-d019-4ca1-8534-c23244d612d4@gmail.com>
 <425c1552139b4f09a5db42459fa74a08@realtek.com>
 <f82ea5e6-d9ef-4978-9658-7e8ce760c7ae@gmail.com>
 <a7791242312c71dfaa96c25aff7be7fb147dea8a@linux.dev>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <a7791242312c71dfaa96c25aff7be7fb147dea8a@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 20/10/2026 00:05, Luka Gejak wrote:
> Hi Bitterblue,
> 
> October 19, 2026 at 10:37 PM, "Bitterblue Smith" <rtl8821cerfe2@gmail.com> wrote:
> 
>>
>> On 19/10/2026 05:39, Ping-Ke Shih wrote:
>>
>>>
>>> Bitterblue Smith <rtl8821cerfe2@gmail.com> wrote:
>>>  
>>>  [...]
>>>  
>>>
>>>>
>>>> +static void rtw8723b_read_package_type(struct rtw_dev *rtwdev)
>>>>  +{
>>>>  + struct rtw_hal *hal = &rtwdev->hal;
>>>>  + u8 val_1fb;
>>>>  +
>>>>  + rtw8723b_efuse_grant(rtwdev, true);
>>>>  + rtw_read8_physical_efuse(rtwdev, 0x1fb, &val_1fb);
>>>>  + rtw8723b_efuse_grant(rtwdev, false);
>>>>
>>>  
>>>  In rtw_parse_efuse_map(), we can pass 'phy_map' to read_efuse()?
>>>  -chip->ops->read_efuse(rtwdev, log_map);
>>>  +chip->ops->read_efuse(rtwdev, log_map, phy_map);
>>>  
>>>  As .phy_efuse_size = 512 for RTL7823B, I think it will work.
>>>
>> Yes, that should work.
>>
>>>
>>>>
>>>> +
>>>>  + switch (u8_get_bits(val_1fb, GENMASK(2, 0))) {
>>>>
>>>  
>>>  Bit 2~0 seems like PKG_TYPE. Define an enum?
>>>  
>>>
>>>>
>>>> + case 0x4:
>>>>  + hal->pkg_type = RTW8723B_PACKAGE_TFBGA79;
>>>>  + break;
>>>>  + case 0x5:
>>>>  + hal->pkg_type = RTW8723B_PACKAGE_TFBGA90;
>>>>  + break;
>>>>  + case 0x6:
>>>>  + hal->pkg_type = RTW8723B_PACKAGE_QFN68;
>>>>  + break;
>>>>  + case 0x7:
>>>>  + hal->pkg_type = RTW8723B_PACKAGE_TFBGA80;
>>>>  + break;
>>>>  + default:
>>>>  + hal->pkg_type = RTW8723B_PACKAGE_DEFAULT;
>>>>  + break;
>>>>  + }
>>>>  +
>>>>  + if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_SDIO &&
>>>>  + u8_get_bits(val_1fb, GENMASK(5, 4)) == 0x2)
>>>>
>>>  
>>>  Can you define enums for bit 5-4 and value 0x2?
>>>  I'm not sure if vendor driver has some comments pointing out this or not.
>>>
>> I guess bits 5-4 identify the chip variant:
>>
>>  /* RTL8703AS: 0x1FB[5:4] 2b'10 */
>>  /* RTL8723BS: 0x1FB[5:4] 2b'11 */
>>  if ((efuseContent & 0x30) == 0x20) {
>>  pAdapter->registrypriv.bw_mode &= 0xF0;
>>  RTW_INFO("This is the case of 8703AS\n");
>>  }
>>
>> RTL8703AS appears to be a (cheaper?) version of RTL8723BS. Ten years ago
>> Hans de Goede was saying:
>>
>>  The rtl8703as in reality is a rtl8723bs in a different package.
>>  (it has the same sdio-id).
>>
>>  In android the rtl8703as uses the rtl8723bs-vq0 driver instead of the
>>  regular rtl8732bs driver. Looking at a diff between the 2 the only
>>  difference is that the vq0 driver forces the antenna-path to
>>  ODM_RF_PATH_B.
>>
>>  It seems that we can identify the rtl8703as by its package, as it comes
>>  in a QNF68 package, where as the rtl8723bs comes in a TFBGA79 package,
>>  so we can simply support both in the same driver.
>>
>> https://github.com/hadess/rtl8723bs/pull/93/changes/ebec0ae8ccedc05a945478926d52c99277f500ee
> 
> So 8703AS should work just fine with rtw8723b. The one thing I'm not
> sure about is antenna path. The vq0 driver hardcodes path B, but the
> normal driver reads it from efuse, same as rtw88. If some 8703AS boards
> have it wrong in efuse we might need a quirk. Have you come across such?
> 

No, I only have RTL8723BU.

> Best regards,
> Luka Gejak


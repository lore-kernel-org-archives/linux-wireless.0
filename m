Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC38737A83B
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 11:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784029017; cv=none; b=R+tOvUyCvTiSyuDdEDcJWOGo+jIzRY0+2gYvkC5pKPnh16OgLornR9cuHrUe5lpcqvBKWgZDluhPQkPDiVOOlpQURnIZlNsn9wUKpQ8r3AzRkmgKl8C4NHTAVZDnWbNox2p4URXzs9W+qOYmHBtGlMW92D88t6CgdU2uk/XK9gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784029017; c=relaxed/simple;
	bh=YxkQkWICPhQGLkkQ0xsdSLcmbHGn74egjdov70IIr8g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BXeLZyj3yglBZRbnMjuDTxScA0RwZI+5RYDd9AUh9Gu8bmjN9SBfWkPFC+diJWMyEtQe2hLWE8lHhtiuz0fBRbwFYPhYxJ+y/t74gJt4ykssBK7BrfgblXtNTrfH/w4hP8bHJky/n8XdDPQ6/yEIO2PJNTgDUICTJD43jWwFISE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UBd566h9; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UBd566h9"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-47f36a122fdso881320f8f.2
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 04:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784029014; x=1784633814; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=POPJlrnK2D0qG77fiLkD0qQ1nI9Mz5LZnibeXX3HCuM=;
        b=UBd566h9kG9D+99oRrb4+50l1VJAYcFDo9RYNQKT5atK7jvOdBE93ge9zvncdYOoOj
         qvk96C8RxSpnzKVbz1r8CRN0X3geiU7+TJY/EC2u+oSnNKzuB1oSWaBSB72B3rK0qIyP
         dFX+KcTw7JqGHQ0uThmp+q6hhRocoWIPKl7mjEo07snZMpg895q7agrWZj08Awgin8hx
         RliyKg3DpLR6CtA+GsYQ7/Z6iwGN7E+3u0nvDv61iD4N7uYdGVY+69NIOZY7yYxVYaDV
         KCKC/ehUe20dJF44FzEEhtWpCxFjcSTYM2RTX74an2pcViHvDe7pm7NJU/lhMlGJm/o7
         MT8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784029014; x=1784633814;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=POPJlrnK2D0qG77fiLkD0qQ1nI9Mz5LZnibeXX3HCuM=;
        b=VN4tXqNHU0ilNG7vYPBATK679CA+wJxgZ4AV5n8+7hiZhstWE7wgCKnIh7g2JGm4z0
         5+nyzUjNx9xWcEA+g5hgMq9RrCWqSKYT2Ofm30YnJ+rzSP1AiXf0sJUMy/huMF2OJP1D
         dVYHqVnAnz1rRG0JzPo0qM60SXDe1yBXdFlboSgBxHk+5TJnEZvz18FCjW7a6npaDbMn
         3BLeyHsv87vGsCZrP1lJlWSJwzqk0SjTWw7FaPp0KS3LdzCI63EhCpSgmbjXIlzPNIKU
         egKAFCgQ9WOYnIZMtHt8I20gHBQCXg4r9qLJeLeZznV9N6j82DXPVPR4U4ypw4HD18CH
         wiKw==
X-Forwarded-Encrypted: i=1; AHgh+RpdkDH8+XfQkt4vndExXR5Erk6+se+CxIvtgNE6riAuVZuV06zLYoujquCbMmnFZETZuptL+zALQOvUJ9gWig==@vger.kernel.org
X-Gm-Message-State: AOJu0YyyS3JO7/Z6XC3VoexqCCcBs60mSXoPOwpVWmN4F7k4++ldmLv7
	fq+l+FSXMOOXZumFZJfWgVfD2FypwVzv4Ydy26OsTOpdeozWT3ZA85nu
X-Gm-Gg: AfdE7cnCFW298CJ+4uqV+AbwfvnIajVOERXvPdU9GeNcqahwwYr9++q+EjQDAtvEXEf
	dmYlRDxcWjTmFy/LYqHbl1iF7v8dXriFa+5oZ4m0/wIiTN1kezs8MP+LbLr++ps9op6YZy5QRGd
	rjI1JnYcNbNeB774tMOYGx2TirEb6SWriKlb9aUXogt1oYfJzgEwZCQNQPZADcksa30IRQeCH+R
	c/O580toi1yN1KqRiIxIjSFHreGrIqkHw7yFyhBRIFuMqkvm1H9sLAezxuOPizAE4GsZ6DEP5FO
	YG72FOSWuy2uFvdTt6SSd7fKbnJW/3aV7mTRXrZDq/Gr7QChcmAFWf1bKjZemOXjJKQt7o5uzpf
	9JGtyg3FKIMiuKm3msFu6UQYjAiV6AMpgX+EiXKfVDnlZl3bEM7Ex/WrKzRWRG2WdyjCIC82S3/
	vfmlqLEoerslflzI26oIS7xIy9Wqg2MGY=
X-Received: by 2002:a05:6000:240a:b0:46e:483c:2262 with SMTP id ffacd0b85a97d-47f2dcdecc8mr15975341f8f.14.1784029013868;
        Tue, 14 Jul 2026 04:36:53 -0700 (PDT)
Received: from [192.168.1.50] ([79.118.68.203])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f4634e0e4sm7929635f8f.4.2026.07.14.04.36.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2026 04:36:53 -0700 (PDT)
Message-ID: <3aad3de5-995c-4a08-a9ee-46d6821ac715@gmail.com>
Date: Tue, 14 Jul 2026 14:36:50 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rtw-next 08/16] wifi: rtw89: add IO offload support via
 firmware
To: Ping-Ke Shih <pkshih@realtek.com>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "Leo.Li" <leo.li@realtek.com>, Gary Chang <gary.chang@realtek.com>,
 Eric Huang <echuang@realtek.com>, Johnson Tsai <wenjie.tsai@realtek.com>,
 Bernie Huang <phhuang@realtek.com>, Isaiah <isaiah@realtek.com>,
 Zong-Zhe Yang <kevin_yang@realtek.com>, Mh_chen <mh_chen@realtek.com>
References: <20260420034051.17666-1-pkshih@realtek.com>
 <20260420034051.17666-9-pkshih@realtek.com>
 <c2c05574-2179-4b9e-b681-90387bea3561@gmail.com>
 <6fa6264e9a86488abfd971a32bfcf44a@realtek.com>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <6fa6264e9a86488abfd971a32bfcf44a@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 14/07/2026 10:53, Ping-Ke Shih wrote:
> Bitterblue Smith <rtl8821cerfe2@gmail.com> wrote:
>> On 20/04/2026 06:40, Ping-Ke Shih wrote:
>>> +static void rtw89_fw_cmd_ofld_udelay(struct rtw89_dev *rtwdev, u32 us)
>>> +{
>>> +     struct rtw89_fw_cmd_ofld_arg cmd = {
>>> +             .src = RTW89_FW_CMD_OFLD_SRC_OTHER,
>>> +             .type = RTW89_FW_CMD_OFLD_DELAY,
>>> +             .value = us,
>>> +     };
>>> +     int ret;
>>> +
>>> +     ret = rtw89_fw_cmd_ofld_enqueue(rtwdev, &cmd);
>>> +     if (ret)
>>> +             udelay(us);
>>> +}
>>> +
>>> +static void rtw89_fw_cmd_ofld_mdelay(struct rtw89_dev *rtwdev, u32 ms)
>>> +{
>>> +     struct rtw89_fw_cmd_ofld_arg cmd = {
>>> +             .src = RTW89_FW_CMD_OFLD_SRC_OTHER,
>>> +             .type = RTW89_FW_CMD_OFLD_DELAY,
>>> +             .value = ms * 1000,
>>> +     };
>>> +     int ret;
>>> +
>>> +     ret = rtw89_fw_cmd_ofld_enqueue(rtwdev, &cmd);
>>> +     if (ret)
>>> +             mdelay(ms);
>>> +}
>> This can fail to compile with some kernel configurations because
>> RTW89_FW_CMD_OFLD_SRC_OTHER (4) doesn't fit in the mask
>> RTW89_H2C_CMD_OFLD_W0_SRC (GENMASK(0, 1)):
> 
> Thanks for the report.
> 
> I sent a patch [1] with first github link. If this the link isn't good to you,
> please let me know. I can change it.
> 
> [1] https://lore.kernel.org/linux-wireless/20260714074811.30124-1-pkshih@realtek.com/T/#u
> 
> 
> 
> 

It looks good to me, thank you.

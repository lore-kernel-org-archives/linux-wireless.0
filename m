Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CB44219E9
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 09:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789377753; cv=none; b=ropeCbXOkhibBAVWYF709L9qZAMSt73lvYi5VFwugCzKvBl8i3oMe0/sp1bo248jvkxYW/PNgbtou/CRW8q2XZiM09K9HtGVBqmMH5smUe3rj6CbPtQGRbM+LpRxhb6z1jtePMGw6V59X2bYv45WhWVjiM8qT0ONLOOYNFWLtT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789377753; c=relaxed/simple;
	bh=OAtE7yv4CVC89kyKndNvZWLG7CJ1s2yNKuYX9cqpjyU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dWhcCWmhMK5sfVEsWFi2JTtOhQ+yE/REXk9ypyOX+sYl3TVTzUqQ3UmE96Kjzwx0kNXmvdNT55B6t21S9WJeAn/SzWzze3Gs+3Jt3/skZL54yaW5yz4WkGKnoD3kTPEF+hZa1+84ifgctAzMbRnERzpvkcxc1ZkzYB79f528ZzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LBaLd3mW; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LBaLd3mW"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-48583cb7d44so194248f8f.3
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 02:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789377749; x=1789982549; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2ehvTkg5zaOtR52PQwJqvfqf51Pp2JzX0vbba6WO6QU=;
        b=LBaLd3mWo/3F7zdSrCSjrjJ0EIqyyNMEwJw82La4QFCgKEZ6OXmAA56jVz9XdCCi9j
         pTpu3YnLP3Uc0rou6moVB7j+lEO5LyHc4cdJpjujo6LDeXs01N+oqh910LtxHN86HZeK
         mCOSHGsbKN/Hqbb/D3KPCcD/y2+J5NakLfT9etnLnG4Df1EPsf0G6vHg53S5IyWnwb+h
         fo7fso3KwUCfBEsodqf43zxKQ1kc3kSEiL8tl/h4mPtc3iQlNCsPY4sADq8yL13QyQme
         CyqpKe6aWjtMJp5GVKNpNPUWJb7aLaziD8MjcLzkl5RRaI9yQUfI4ZdJpH7HeqzFLPSZ
         nUtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789377749; x=1789982549;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2ehvTkg5zaOtR52PQwJqvfqf51Pp2JzX0vbba6WO6QU=;
        b=cuDgOtTRHHerNBY0o/VGjfc18uqkyfvVIp7sUmZQu7lXo3lJxxtz7ZtWZ3UlMyMGzH
         rYoUAGNukcoc3OIiWkHjct/yyeDC4rDYhxyGZz/E0wQi6rccYzMAty8uopfEr6X6XfvJ
         cw7quWDI0avU1WQtIFDXvp64p3hdtbBb8EdGj/+ffj8QJqGnIGIHwBAbP9JQZHzIUQnb
         sh6K3SFPVdBkAgEoayCU19MMA/fNv6fp40Mpv5ITItDPFv/95pTfJGZUmhfvX36O6fEH
         pFpOO5nsX2VjDEplQfzXh/VNk44ABSTznZvKqIos9QAL/qFgh+4btvTmZV6Lysm9xZjA
         CdqA==
X-Forwarded-Encrypted: i=1; AKwUvBx0e+bF/vXqIyCscZ6I+5K/T0RiWcdiXm0Ps20SnGBbGVOGBMbytNsmvtld+Bz8v8pjGeCHB+8Tf/wJM1XMZA==@vger.kernel.org
X-Gm-Message-State: AFuF++kzaQ5dxw4oiIYq19EgZcsk+XzeckdFcZbaU+jWEZ5yGBJJk1Y4
	vA/EIDmAkkO3CSr4jK0/gu9YnipdriZQmK1NMK0O0PB0wFTPTfwO89UIDNFpl9mH
X-Gm-Gg: AYBFou2hxvXeU2Y0atusqLjmeb8aMW+RONMN2B0oHfEtyjnfsRnsyJiroZahoy9b3ja
	XAhp/lzKaAwBOZ2QOAOGOSh0FZLly7Satz87FLhwGYf5JCuddOmAK8KUdJFaYcTKXSGjpEVYplx
	X3AtGj7WCLksTmGdHXFaMTg5aY0bUgFzMRLSHywXeo2Mp+S/X9X0t+N+n3BlQw8KX/qQYvkLbf+
	zqSYIw2jupzx6UJuvoF81aFuMSHqxg+DGgQsqCqyKhTDtYDrRGvd0z/QsMtDQcQkdNy+B2fG0Jo
	G2jGoGsRI+q2ODNmDIf+U+jsLZ9toXDZllp1CraMQcmPHzEvAvRVsP33ykADYJAv3YXZOQDax8p
	NRQsZ4tdd6cGBEcSxnohYN8BSil42fwohTle6d7h0PZ2HfV4jtiw4g1H22YrM1YiX9H7AUTm6b+
	lv2mHIJ0a1/9+exH1V/hMwCCztzKUxmlvmNp1+I587uV0CulMnlESvgL7+unQ3d9uGwKOrIlLm2
	MGYBybrFAUwl5v2iDO64KlkF1vqwkPkveODElTxfw==
X-Received: by 2002:a05:6000:46c5:b0:487:403:84ee with SMTP id ffacd0b85a97d-487040385d9mr429203f8f.0.1789377749303;
        Mon, 14 Sep 2026 02:22:29 -0700 (PDT)
Received: from [128.93.83.149] (wifi-pro-83-149.paris.inria.fr. [128.93.83.149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb35c071sm25530637f8f.33.2026.09.14.02.22.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 02:22:28 -0700 (PDT)
Message-ID: <2fbaf498-bec4-4f83-8fba-daa57ddef5fd@gmail.com>
Date: Mon, 14 Sep 2026 11:22:28 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] wifi: ath9k: Fix potential spin_lock() before
 spin_lock_init()
To: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: Kalle Valo <kvalo@kernel.org>,
 "open list:QUALCOMM ATHEROS ATH9K WIRELESS DRIVER"
 <linux-wireless@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20260804080913.67985-2-fourier.thomas@gmail.com>
 <87pkyof636.fsf@toke.dk>
Content-Language: en-US
From: Thomas Fourier <fourier.thomas@gmail.com>
In-Reply-To: <87pkyof636.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 08/09/2026 11:25, Toke Høiland-Jørgensen wrote:
> Thomas Fourier <fourier.thomas@gmail.com> writes:
> 
>> The function ath9k_init_wmi() initializes wmi->wmi_lock. It is called in
>> ath9k_htc_probe_device(), and the priv->initialized flag is set.
>> However, the ath9k_wmi_event_tasklet takes the lock before checking the
>> priv->initialized flag, so the lock may not be initialized before
>> being taken.  This could be the case, for example, if the spin_lock_init()
>> is reordered with tasklet_setup() in ath9k_init_wmi() by the compiler or
>> CPU.
>>
>> There is a write memory barrier before setting the priv->initialized,
>> but no corresponding read memory barrier is used after checking the
>> flag.
>>
>> Move priv->initialized at the start of ath9k_wmi_event_tasklet() and
>> add a corresponding read memory barrier.
>>
>> Fixes: 24355fcb0d4c ("wifi: ath9k: delay all of ath9k_wmi_event_tasklet() until init is complete")
>> Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
>> ---
>>   drivers/net/wireless/ath/ath9k/wmi.c | 15 +++++++++------
>>   1 file changed, 9 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
>> index 284e8c13b043..df4a3a625536 100644
>> --- a/drivers/net/wireless/ath/ath9k/wmi.c
>> +++ b/drivers/net/wireless/ath/ath9k/wmi.c
>> @@ -146,6 +146,15 @@ void ath9k_wmi_event_tasklet(struct tasklet_struct *t)
>>   	unsigned long flags;
>>   	u16 cmd_id;
>>   
>> +	/* Check if ath9k_htc_probe_device() completed. */
>> +	if (!data_race(priv->initialized))
>> +		return;
> 
> Moving this out of the loop changes behaviour: Before, the loop would
> keep spinning waiting for initialisation, now we just exit. I don't see
> any guarantee that we'll come back here, so this has the risk of
> stalling things. We'll need to re-schedule the tasklet before returning
> if we're moving the check here.
Thank you for your comment.

I'm not sure that I agree that the tasklet needs to be rescheduled. 
Yes, the behavior is changed, as you described, but when a packet is 
dequeued, in normal operations, the function ends (either with a return 
or break statement). This means that the function is scheduled regularly.

To not change the behavior while still fixing the potential lock on 
uninitialized lock (and the missing memory barrier), we could move the 
initialization check at the very start of the loop like so:

diff --git a/drivers/net/wireless/ath/ath9k/wmi.c 
b/drivers/net/wireless/ath/ath9k/wmi.c
index 284e8c13b043..a21c438e5b61 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -147,6 +147,17 @@ void ath9k_wmi_event_tasklet(struct tasklet_struct *t)
         u16 cmd_id;

         do {
+               /* Check if ath9k_htc_probe_device() completed. */
+               if (!data_race(priv->initialized)) {
+                       kfree_skb(skb);
+                       continue;
+               }
+               /*
+                * Make sure ath9k_htc_probe_device() initialization is
+                * committed to memory before processing skb.
+                */
+               smp_rmb();
+
                 spin_lock_irqsave(&wmi->wmi_lock, flags);
                 skb = __skb_dequeue(&wmi->wmi_event_queue);
                 if (!skb) {
@@ -155,12 +166,6 @@ void ath9k_wmi_event_tasklet(struct tasklet_struct *t)
                 }
                 spin_unlock_irqrestore(&wmi->wmi_lock, flags);

-               /* Check if ath9k_htc_probe_device() completed. */
-               if (!data_race(priv->initialized)) {
-                       kfree_skb(skb);
-                       continue;
-               }
-
                 hdr = (struct wmi_cmd_hdr *) skb->data;
                 cmd_id = be16_to_cpu(hdr->command_id);
                 wmi_event = skb_pull(skb, sizeof(struct wmi_cmd_hdr));

---

Maybe that would be better?

Best,
Thomas>
> -Toke


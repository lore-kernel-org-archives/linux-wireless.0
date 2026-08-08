Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D1C2E737E
	for <linux-wireless@vger.kernel.org>; Sat,  8 Aug 2026 11:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786188785; cv=none; b=kqxAWrtujoLCKUx007mJVQH17ezAKy5om+Jlcn2zegHvafSwI3f/4pCuTyeLksr4sfROMjpZdpc5nbKBpX/PmHzBtw5d2bMbla9sUdbwGBSYmRXf1WiF16Boh3bAEURtvxf39s7EptTvZli8nG4luOF91Kfm1ZYUWRqNP4qCyG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786188785; c=relaxed/simple;
	bh=D1xEcmhhf1a68HQLmZt6TiNTbKHxIfIp4aGjlkSzidA=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=mxL3oT9wi02LLF592K4MqrjXNv2E09EcPvipd4BDxbG+9OxQKF5yehjguCGxWuB52w0JP5YFOMGv9QsYGJcc7n03l282weEBjZPRNpJKdRB9Usl7bmlVC6lwYi89NCdSqImX99mOjdXt/LuS5/5cX0ZiY90m5DV0ZeRG1DuUsJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NqWL5roL; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NqWL5roL"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4954df200ddso2329235e9.0
        for <linux-wireless@vger.kernel.org>; Sat, 08 Aug 2026 04:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786188782; x=1786793582; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=PD/+vGGo80Tk1YVcv2e7nHyQRYQQpC76abSxLSltLaI=;
        b=NqWL5roLJAl/HxkDXDFJJQHdljJf3BRpT9Le2WitedmJ6H0j/t8MzM7tDhHVi0BwTz
         vMUDBcVHNYsOd/9GvV6cxjBgJdKPyd3GN774HYhnqD/NSkuKDG3VObDx+Kp804ocqLqs
         c6WC/DU2egZrxoQvqCxCz5HrdlV6RboJ04skecsYgchQEuzy3FGOKzPOOe+srp2VJpFJ
         jET86PpR5B8Xyz825TKqy3v7fBCskF/aCITd5cymHVHqIwKE5dMHpfW1O9L8m+l7umOn
         0oZB2VbwcWUi96314ZU8p0RSLxQJavpruLBYgOo2QN2GCIVVbJn7++99X1QG2oCyDTR3
         7Ovw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786188782; x=1786793582;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PD/+vGGo80Tk1YVcv2e7nHyQRYQQpC76abSxLSltLaI=;
        b=q6Svo7XvQUApvdTCrUg04UcRmKOL/wzlYzSj2rWE5LlHyEBqSrOwAYj2JwDPNo6zM5
         5GRaAfkYaosRR9vFXEqK9g6RXuD1A2gKs9xa28jfDr2/7aceEHkrdb5dtt3Ql3ouG2Lq
         RLm/gK1cGdoh7hye2grWDz+onkSHesfw36hJiL2w/glUzi4Ah5dj7IYJ92xe+kyFHaZ7
         ARlYC6IJm1Heze9NZ5X7/bp2nInVpaXrjq8EQvGeR50+qrFhBoYonLxL5wnB0Yybhia7
         LrWeNshpXIhuSg2soV2D2cGfvtKpyYqE9etetWOY7TPCO4IFN63LqI5G7CktPnapYlKM
         isHQ==
X-Gm-Message-State: AOJu0YxtBqLauf25nlm09i7CRJ09/UkGAUatwqnvS8WD/9gwWTIij02o
	3LzB9ScFt0RKrqUEQOPf7nBv4GB3KfEJzbyRvd3tUXWJ3xzCc/go3WWyQLHy17zx
X-Gm-Gg: AR+sD11RbstjI5hlmRm/ILluIidus79E7DkWB9cNpKjLU9UerUNvRzsdsVnX4g4C9w+
	R5ZtR49UhN9Ml+2qlWyUxug8Erceed2TCO/QjBX/12gc4qAy4rzZVZ4puYCfHj8GDtiwEvczaz8
	548xq0Zwmla/2QI+ChOBqbYXgTTpCM5GOTr98ZvI5XwUUcKLThojGl3tpobRxj8dLyfJ+6Gp/e7
	1H+gYs/84i4eTV57v4Tyr0i3QUMZJFTJXCSWy84stDGGzx/rH3WUU9jNIxerZMbYEbmFBCt7Q6z
	VOLm1jNChvpVCJvnbw6Z/nB+MpZHeiFzbBxDYG0gvD1cNEgKratnyBgXgr9/FFinJkTq/Z0FIue
	d8TeYyo/o88WG+EswcBwJ6DmoY92NpU43XtXHluHkppI6I5hs2qnLQd2iN9yv73sQqmghs3htTP
	5IS5Na5FhjiKZKrL0h9udGCxAcaK8qXIrpoPHzLy9YWs88R3lRlRz8PORy7mVZuIQEQ1yWQiD6/
	8dGyqChi3oGAKMnrEkhiTB6vDtQ7LV8rojXZQCRe1mF1G0neogOqWgj3uKjKYeKmp+yxgj0pGmd
	pIU=
X-Received: by 2002:a05:600c:1c21:b0:493:e460:1f6 with SMTP id 5b1f17b1804b1-4994e6fe377mr386737485e9.0.1786188782291;
        Sat, 08 Aug 2026 04:33:02 -0700 (PDT)
Received: from ?IPV6:2a02:1388:23c0:6b4:aa41:f4ff:fec6:26e2? ([2a02:1388:23c0:6b4:aa41:f4ff:fec6:26e2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499542858b2sm253927675e9.14.2026.08.08.04.33.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2026 04:33:01 -0700 (PDT)
Message-ID: <59a87b27-a3e4-437c-b26b-de61d6d5f1ef@gmail.com>
Date: Sat, 8 Aug 2026 14:33:00 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com
From: Gravias Panagiotis <graviaspanagiotis1@gmail.com>
Subject: [BUG] rtw89: RTL8852BE instant wake from suspend (Unknown wakeup
 reason 0)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

I am experiencing an issue where my laptop instantly wakes from suspend 
(s2idle) due to a spurious interrupt from the RTL8852BE wireless card. 
The system refuses to stay asleep unless I use a workaround.

Hardware: Realtek RTL8852BE Wireless LAN 802.11ax PCI-Express Adapter
Driver: rtw89_8852be
Kernel version: [Insert your output from `uname -r`]
Distribution: Arch Linux

Steps to reproduce:
1. Have RTL8852BE card active and connected to Wi-Fi.
2. Trigger system suspend via `systemctl suspend`.
3. The system begins the sleep process but immediately aborts and wakes 
back up to the lock screen.

Relevant journalctl logs:
kernel: rtw89_8852be 0000:03:00.0: Unknown wakeup reason 0
bluetoothd[785]: Controller resume with wake event 0x0
kernel: PM: suspend exit

It appears the WoWLAN implementation on this specific chip is firing a 
generic 0 interrupt upon entering D3/s2idle state.

It is a personal problem so i would love to contribute in fixing this 
problem. Please let me know if there are any driver parameters or 
patches you would like me to test to help debug this.

Thank you,
Panagiotis Graviasyes

Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C96D54B1BF
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 16:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792080138; cv=pass; b=KgwOx9lVlCZ34mLyKB5uFhUyrPVr8TBh8m0qBLWCT5SJjkx+wkn0mA8UImZPM/KtH+0USs82bJm/sSeZxpxagghhnocSpSgYMLJasOzWhHjw7l7XJdD8l/vvPMOazo8eEL2TI2g8RQrOl0ntjwFaLa/kph0WGk71F5BsNr1X008=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792080138; c=relaxed/simple;
	bh=EVb3fHhqwqqeu00xfzg/DJoG7nkrhX4cn5MUR8Ocoj0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kSMdKPwEZ8bIGFeh5Bx6msCPRzl2HLKdKmIy1twZams4VrLWN4mAXuO90RcexZsO3yHse1b2LUnPDzVBysVJyybxFVo9qtxqtnkReIojZ0RzqueYn9iH4TT211IzoOy6auUlW4Dq2U88xwMVnicVp5wEwDMqHvc0ADIyWjBs4bc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j/lYuoql; arc=pass smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j/lYuoql"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b1f4d8e09aso985388a12.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 09:02:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792080125; cv=none;
        d=google.com; s=arc-20260327;
        b=LRBHSMxDN+FwZHq7esq/1LWhBLPxZV8b5b+FiV4DnVsnT25Rqvb2SgN50x3QXDW0oM
         /aB7dRvdctqBPPxdLfnb37ZAeJtPF1/77X+oLq7d2dtbQYvQPwsEIDlJsj8x9xOiMqzs
         PyUwZ9ca9KIviNHeoptp3rqktkB+HvHOVsWJNMpwyf1M0K32Tv6rtTWGyjpFUNssWqke
         dSlWOBpP7QBciZtDx/yuPnS74T31QE1CgMmoRNRULAc7gHvwdC/gNVi1GKc6opQOhfrn
         GwtZjG8CY73LFJjPqYuW326dRN05cFc8RGf6ME/ixRQR14wuVsve+UPgkPH7yMp4LuJf
         4Gag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=EVb3fHhqwqqeu00xfzg/DJoG7nkrhX4cn5MUR8Ocoj0=;
        fh=JF2GxIl7SiD0CQWLIG0nD20+cSgW+Q0grO/hXIWsgAM=;
        b=aTFwQU9Jhorn3olENAstXUpBG3gnyTxWlN0j4yaI8nUAGzFXzoC2rTHDN58wv+pEia
         86LKt2L2M167PFBSpV74jgRKNhRBA25Ic1BV5hKbFaU/FIPE5odkYOsmoqBnflA+iiks
         FX4btRJWfzqBDuv8RMElb0LT8kc0wwj81EiF89RhoMszOWLL/gy5tvU89aMB47fE3dJT
         XAuHODkV7v5CQfnAzGvnjYHr+s/W3oVZkeMg4qUrbxANKb2B0QOVepB4W6FjwTS4F7Tx
         /XZsPeuU11baHwFhSaHpG/35OpEoqCJOBRyEQp/3sVcpwbw4KvK9tkZgOXl5UysKSeCo
         56iA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792080125; x=1792684925; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EVb3fHhqwqqeu00xfzg/DJoG7nkrhX4cn5MUR8Ocoj0=;
        b=j/lYuoqlP7GdMXuIA+bkgEWEjelGTkFfUXSUTwOzMiIv4Rx3U2fZ5uspOV8pBJ8YTQ
         1NBCnVkDeO+8AxTDdBCWKSN4hlwwluNrW0MXPho8XxgLESmGPiC84HnV8q8EtnPitD0g
         o4eqlLYIAe8CKTBrDOyxNZhLhNi1hSzdLCzgV3JGKsmlRaRXUVgkSS5I/mlb3wMxHNKv
         yObtZ/+vYLoyIUkB31qtyGwTTzLuwMg4V/UbN6ziRdoZOBuWeV4AD6W3/5V1IqKcD6QJ
         /kfwWE+Jl05EySFY/Qt0VXVACaJq4+2i5P/ivR8IKwoi/J6iBxAaGKFCopxJL+bUt3ML
         fE7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792080125; x=1792684925;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=EVb3fHhqwqqeu00xfzg/DJoG7nkrhX4cn5MUR8Ocoj0=;
        b=fgxJMcLZ63MW7PAMJnOLJxLYpw7vpjyT26pLGtoEi6fnh0jk/Qw9XAJpsRqh6U75ln
         5Kqp6foe7VeG2EWpU9C4my/jHfzAhtAxbDGPAp82W68zfXe/EoxF59q3cE4HfyS6CWdR
         F/O9d8S7s5nlbo3GTH9ZUsRcM+BZ9xYcy83iU1ZMWU4U+oHEw4kpQbiwPzHhxj4p1sXn
         VBc6KNQ/lAE3TBZ9wAJ1TClMFf2Oe9nWWHcwt61Dfob28u2VuSFBhDAIK3gnb6qYibX+
         UeFv4Wt6nRrGV7C6EypGpnjGZVmNl8EXP7n9tV5TlWmfGpnn6kXrkZhsksLEr0JTAsB3
         VSeg==
X-Gm-Message-State: AFq9FYL18VdJpU5J/aqr5vnJB8TE6U2JieinEh0UIT8dCsKzI7JzmXw4
	+aIHQ2U4fmBc5oR89EbBv/BTn/tex8uzvsjTwzTmFKZw6TexWxgNdS3Ow0eweTlvgIofONZC9qI
	N1FxiRu3IfSxh9HldTwWk5GCznFGwfaI=
X-Gm-Gg: AYBFou2qQjR5fGN2eAYTL3gktxMxxqRJo9FzY4h7+BXHFhPHshP991DmEDKvtGBgUDM
	700X0aZ+HCFeNP3/rNfUQBFeMApWYv2xCQ/VfUFVk3fsqJlK1dxatJh7yZGHAnH2hg85pqJcvF8
	JHQkltwweQNIajOOa1FoDqiBC2GUJKdyJpChm9P0UBUqADXoszcsf49Goxoflmox/lAt/nm6vDO
	f3MPvoC2pU+3/KzRM+9A9OlLlrkP/pfEjKZDyQMIwXMkGTD1+Z1DSSEnf9apn8liv2z/+/M4yJ7
	ITxf2nZwYKd0x3Wpr99V85FA5pHuty/3BOOU++xxZGPVag3nnlEmN0AvOPBQrQiXu6n5Rls554i
	DzFSjUQ2kC4G2LK+ddI+XlidaYJyezDQzScs6gW8fsPhABB8P
X-Received: by 2002:a17:906:dc8c:b0:c2d:ba08:9092 with SMTP id
 a640c23a62f3a-c31a9fe730dmr1747152466b.16.1792080124947; Thu, 15 Oct 2026
 09:02:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGHkXsZX7Tnze+rqJY=D5Zz2Vo=t2Hee28pDxFpoE+Lno+EcxA@mail.gmail.com>
 <048365a7-0ce0-4f98-98d2-eb040ff87b39@oss.qualcomm.com>
In-Reply-To: <048365a7-0ce0-4f98-98d2-eb040ff87b39@oss.qualcomm.com>
From: Enrico <vovkap97@gmail.com>
Date: Thu, 15 Oct 2026 18:01:50 +0200
X-Gm-Features: AclHuK_WegNOp3BqMOJ-WuU1MlOnrtz9IabRYV30HLJ-TtKNk_4nHVlThqvNgcU
Message-ID: <CAGHkXsbsJV+tCWupwKvdysddFqXmZnsv5PtD99vcAxQkp+VrTw@mail.gmail.com>
Subject: Re: [BUG] ath12k: WCN7850 firmware stops uplink TX on EHT (CMD_REMOVE_AGED_FRAMES)
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Jeff Johnson <jjohnson@kernel.org>
Content-Type: text/plain; charset="UTF-8"

> Please open a ticket per:
> https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath12k/bugreport.html

Filed as https://bugzilla.kernel.org/show_bug.cgi?id=222136

Thank you!

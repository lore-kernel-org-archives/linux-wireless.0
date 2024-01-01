Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF16EA3
	for <linux-wireless@vger.kernel.org>; Mon,  1 Jan 2024 05:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RM+JhWf5"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-5bdbe2de25fso6631140a12.3
        for <linux-wireless@vger.kernel.org>; Sun, 31 Dec 2023 21:13:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704086027; x=1704690827; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5AWXGDX/YEN71ImVG3Rdyn4fva3C5cgltnqVgVsg75g=;
        b=RM+JhWf5iWkf3C1ASza6EBjcT+AJI5onB1mQh7sPWU/EmgxgTqT4Gdqrhjhi7PQiSG
         pgXDWQY6ixEYoJ/lGgHHfw4Vmn0NxD803ObV5tFXX0M1q8uKuMGle1FOjoVAc6agadVz
         jn9XMY++6GzY0H+lBynbG7AX7ngwBgn2k4Ar3MH9ZrPeVzl+2MSh3ZTehobRny1wKG17
         t0jnrfqkCkdQGY+BPeed3rDH1UKUJY49FKen996OW7kj+tmsH+TPaR3O4SFxSHHZmqFe
         gz5VdXIM2fjA08fpfE53Hi3Xuse64IB6B4a+lHvxq3/1kgr8n5Yqusb6v3E8N7aN1Csc
         Uvmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704086027; x=1704690827;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5AWXGDX/YEN71ImVG3Rdyn4fva3C5cgltnqVgVsg75g=;
        b=AIT7sKnevqXzmAEnMVfIMrJdSk6UOli2EJUloRBluSV2qA+WRuyBIGOPW5OMnP8NTa
         6gDn9/ETVSqHuzHgdF1TQnHk1x+a0KqsKKlm8FMCIDfsFcRN2X96AXsXykOFL8PrtfHu
         1aFocQj/S1QNryDUw6k9GkrmYkme3Sn+XUjy/xXlq2xVki3McN/Jf9yq+h1oX/h3H2n0
         AZRlPEAiVDBh3OaoPtVp/CBNxjXBj1pgCA3YAgYgf2QwRHXxqdkvOOcVEz9PuAKrFhGk
         WqmL6kbk7YwXsxfnFL0OtfD19fCWOcM8hL2/cPqc0tk7UNPmZxXeG7BUUY1lka4D3Y1I
         a9Tw==
X-Gm-Message-State: AOJu0Yz8awkQ4GW0p2t9LmnN7OOLgGdJmh8HR2p+ZgFx97nWtbXdJKLa
	NoeKTQAsZjix9cNeTTqnMumTeUieXjZI3g==
X-Google-Smtp-Source: AGHT+IFlGdT85gBHLK+/+HlkWUJ26GU5DmSFCDp5O2iNdirqL/qih2zN5/8GQJEcPoGaGirqnW8OYA==
X-Received: by 2002:a05:6a20:9389:b0:196:a680:58c3 with SMTP id x9-20020a056a20938900b00196a68058c3mr4715710pzh.58.1704086027511;
        Sun, 31 Dec 2023 21:13:47 -0800 (PST)
Received: from localhost.localdomain ([112.78.94.107])
        by smtp.googlemail.com with ESMTPSA id c30-20020a630d1e000000b005c2185be2basm17823043pgl.54.2023.12.31.21.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Dec 2023 21:13:47 -0800 (PST)
From: Zenm Chen <zenmchen@gmail.com>
To: rtl8821cerfe2@gmail.com
Cc: Jes.Sorensen@gmail.com,
	linux-wireless@vger.kernel.org,
	pkshih@realtek.com,
	zenmchen@gmail.com
Subject: [PATCH v3] wifi: rtl8xxxu: Fix LED control code of RTL8192FU
Date: Mon,  1 Jan 2024 13:13:42 +0800
Message-ID: <20240101051342.8703-1-zenmchen@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <7a2c3158-3a45-4466-b11e-fc09802b20e2@gmail.com>
References: <7a2c3158-3a45-4466-b11e-fc09802b20e2@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Thanks for making this patch.
I have no ASUS USB-N13 C1 now, so only tested with MERCUSYS MW310UH.
I think this patch will make the LEDs of ASUS USB-N13 C1/EDIMAX EW-7722UTn V3 work as expected.


Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5653E360745
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 15:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238706; cv=pass; b=YiD1ncu7Qo9AwXrKMpyjJR4gvcfqn7tyZWFsHYjTH/wfP+IwRYvMrj2WacIQe51suKiSg+jPBpz1ZuBUP/oetmscGwqQMPEWuw+hZqyGttQTANPnPg3hbMIjpkBXcq6/eRnct8rsG4WPhxBvZ3J1s7ZQVVFWrAdEg5Z+6nmn410=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238706; c=relaxed/simple;
	bh=QMkUsuxGydmKbq1b6Y5RnuL7lKyi2ov0l92WEqp/q0w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X1aYtKY1BBxmm0l1OvsRak4ieraLlmA4T6yGUXxjdos06yo8a2TcTEN7tZbpeeNAG1idbbMrFnEvGaRWHPp3I9yTHxMrL1FhTX0EonQarXjNMB5FkAnyCFz4rpHM8sTredbsOmVrAQUCtRh5KSt9xo/XKzUkomwQ20MySZvv5o8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q1GIS4by; arc=pass smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q1GIS4by"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8efcef23d21so17260336d6.2
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 08:11:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787238704; cv=none;
        d=google.com; s=arc-20260327;
        b=T9ieUsGfoBtzLkjejCjVsT8NB1LkZ8hFS/sKrEVD/a7UG88HVOTTqAAFhEj+rMXzmq
         1m07naDBJpa/JRwi2FQyVX38jtlfU0KuLNM7/qIU44oEnwTSfo3/rnp+ALf8SehpQTvV
         Pg4NnF4DqahVRNX/R4i85TilRyn/3q2Wm5D8VWfVsFEdyLe2dZ4T3wW7zNs9fB2j04A3
         Ye5oVD5jvGJme44VPfPCztpqorxQck8jvz/rK3ZMPJYaNxKFosaLd4PeVrs1dtcC/2/9
         nO8eLtlfriY0jHlivOozyio5ULDUdqKLBPPlgQRtmuU8g5l6OBb6ZRntCb3pxDg0kUJb
         XwEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=QMkUsuxGydmKbq1b6Y5RnuL7lKyi2ov0l92WEqp/q0w=;
        fh=419OJlkWAeADK3MgxNrCFC1nDEs30SgaK39sj/Fa36M=;
        b=X3oYPHAkz3lpFNbmfD+jTjqllBEJi+1i6NjcAhpHTSbtZ0s7hPREpW8nIIirCl2x/F
         RMc5S+63JSRSJUicUblmutoHoVz42kf8auxwgl9B/RfNMl15B0m7DkYpfJSFBx69kOy6
         Bfpss24dHe5oRAQtFAmw7X2ikM8skQ7xCIqYH5veNbjt0s2d60DLLm2ut+OQOFmQtMQ9
         PhU+nAxhbrv8yekszrjlWZ2P82cXv14YMk8SaO8stBXKFJ1fKzXqhDNq8VHEuMUNRUI6
         LtIjAvFedlCQBaAMBvTuMNExI0CnV/mkue03W+PavMjy8VetiI1BWP1StmYEQaGrufxv
         v56g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787238704; x=1787843504; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QMkUsuxGydmKbq1b6Y5RnuL7lKyi2ov0l92WEqp/q0w=;
        b=Q1GIS4byw5rNGLxwz+wQ09lpAD0ydtPvft7Wbr2c1fYm30RKVz1+Yb6Qf1V/iZd7Zc
         bIRx9t0XHc1LUfHUB723nA9Wwu1SVx0/QyH/KPQG/vGzk0cDsex7as9aU4gtBdIjhwkm
         oKi8utNS0TFi/TE204P7HgkgP61A27Yb924EhKwm0InXLOLNbmIF+6zwp/dwlsqzp8gP
         LSbWYlCdc4kGwofbvNcXY/YerdZEcotiFLkDiAc9Zd75X1AMfmVsSebOvIvanrm5gUYy
         s2tzkA6H8t0cU5RA3sAWrYN/dWXYBthGDq5bQT77tAbjXqHpFhJdsK078wACnMqfAOVG
         if2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787238704; x=1787843504;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QMkUsuxGydmKbq1b6Y5RnuL7lKyi2ov0l92WEqp/q0w=;
        b=NeLm5+J/lkqg81sNKT/494Fe+K4dbwbTMaIdwR3fFaDpHfP5gWVhQdGhFadkiSz8Tc
         Dmby9iw2gsX71usOl69GYHCJA7WrpUp6SEfz5fQeC7yoBIftaenGb1N2wkxY7IiWKOBl
         rOEshWLHXO9OiYCAGZjz2eGL8rZuqZMLlnZGdkJ75qtTxIH25ZN2RHa8rCSBbicaqSuH
         yYwdjYQgiddxH0/iyycAV2CMltdCbhd1S4fAJYlBofwn2s+ToYzsdLUmruEWZuiMQU53
         wl5AymuAcOzLAd3KOSKzbAODnqxGdtVhK4P8eIEjoW8y4kl8m0hcZzJpvRtqyAa28ix/
         YrFg==
X-Forwarded-Encrypted: i=1; AHgh+RqMldX/jeax5DWw2tx4oz+OblZUak7pSJheLOS29hdRYtqBStqu8B4w/YhHzt+9ZmUgDiVdMaAVgpnC1mqcnw==@vger.kernel.org
X-Gm-Message-State: AFuF++k/f25AibXjsH4p7s/Znu0yrgVia2xgyyLy1L2s8faBTFSFwlv1
	rYdqPuLB/zIANMhiBlpXU4zjqAl4TNZw8npHlI9caKykd5KEM9fehcwcDbg3NM0JEFjDe8KblJG
	AlTeIWNhhMJD+gcwu4DUkSOKZEtYDkreRSOWd
X-Gm-Gg: AR+sD1246k8z0a6bYqDN8IURb0LILBygyPhgUw7fTm9zPGbs8zY/1/BwZkp8YHHAuL2
	Cn1Cy7Mi2Hrtkfjza6fI95wBOZUMX7sMEZ9OvVxnwWX3zQt9Hhfqqq5T9fSsc4nRefZs3dOfb3V
	ps/pYonlYxXvKwW9ZaBBpA4dpzrjKCPsHGQDSn9VC4HmXFYZIn+lNZG42/ax2LHIglbWZnx7hh6
	o5XhjPVFejKEUxiGfkVD4ye0T0XjfZ2gu7+EZYwIicMHBw0+9K7eadQ7OLW2sEMCvhTfdnB8zK9
	5KANKfPPtxyaDfSdj1A4XQgsrLwq943kMQxdiiTxi6TPZXTkPVI/mC1WuDG73mVnEkVWtSfSAG7
	smLBHSVUSYIgrdZeVFWrkaCU99lzzNpxQQrJxJRgL7vzPj+CEnWrtElS/4+NTJbJ3bXx3QERlQO
	x6aB/W/3FEXkvxytJ97BG/I+YtPpAura0HV3SyHUY=
X-Received: by 2002:a05:6214:3284:b0:8f0:d59d:78d2 with SMTP id
 6a1803df08f44-90c5e70349cmr140109856d6.5.1787238703913; Thu, 20 Aug 2026
 08:11:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260814105327.6687-1-luka.gejak@linux.dev> <6C350314-0529-445E-9324-FD5C21C5B495@linux.dev>
 <CALeDE9NmBpsBdVHYuzahgrxKtvzxs-ML1netc7OMOEMQ8j5+vg@mail.gmail.com> <A119CD11-ACC4-403E-B2DD-77ED818708F1@linux.dev>
In-Reply-To: <A119CD11-ACC4-403E-B2DD-77ED818708F1@linux.dev>
From: Peter Robinson <pbrobinson@gmail.com>
Date: Thu, 20 Aug 2026 16:11:31 +0100
X-Gm-Features: AcwNN1Umy_uYGCBr64U4XQ_uZYg1GC5h8AHifDXUQa_GA1TF6GaFqCFqGL9jenA
Message-ID: <CALeDE9PtH3dP0gynxzA7jyJEAXjYiGU8+Q_B6Y5ehZ2K5QgjVA@mail.gmail.com>
Subject: Re: [PATCH v5 0/6] wifi: rtw88: preparations for RTL8723B/RTL8723BS
To: Luka Gejak <luka.gejak@linux.dev>
Cc: Ping-Ke Shih <pkshih@realtek.com>, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Michael Straube <straube.linux@gmail.com>, 
	Bitterblue Smith <rtl8821cerfe2@gmail.com>, Hans de Goede <johannes.goede@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"

Hi Luka,

> >> v7 follows shortly. It is hardware tested: 60 idle pings at 0% loss with
> >> power save on, bidirectional load with no stall, 19.6 Mbit/s up and 36.8
> >> down, UDP at 0% loss, three scans, three reconnects and a clean log.
> >
> >I had done some basic testing with v5, and had left a v6 to build
> >overnight. I'll grab this shortly and do a build with v7 and do some
> >testing.It was generally looking stable on the Pine64+ board I was
> >using for testing.
> >
>
> Thanks a lot for testing. In my testing changes in v6 and v7 didn't impact
> performance and v7 should be as stable if not more stable then v5 and v6.

I've literally just booted v7 so it'll take a bit to test it more.

In v5/v6 I saw a bunch of these once it was running for a while, it
seems to be stable though.

[ 5594.434616] rtw88_8723bs mmc0:0001:1: failed to get tx report from firmware
[ 5692.223363] rtw88_8723bs mmc0:0001:1: failed to get tx report from firmware
[ 5747.389804] rtw88_8723bs mmc0:0001:1: failed to get tx report from firmware
[ 5767.421101] rtw88_8723bs mmc0:0001:1: failed to get tx report from firmware

Testing on iperf3 I'm getting just over 2Mbits/sec both TX/RX overall.

> >I think I may also have a device(s) with a 8723cs and/or a 8723ds I
> >can possibly test with, I'll see if I can remember/find it over the
> >weekend and get it running for some testing of that too.
>
> That would be nice, so we can see if other chips are affected, as Ping-Ke
> said.

I'll try and work out what I have over the weekend and will do some
testing against v7 on both devices.

Peter

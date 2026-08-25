Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F9233B966
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 15:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787672004; cv=pass; b=LU9YD1vKGcGVvdDl1Ks1bnsUhnZe2YBF/mvV2QIf1J36kVC9cHGh8CnNf6vSfP+iD6FQVLaUhUlSU/QUKIxBVHNhYwezCGX2A1a4zKsFd1IqFkWD7V38Y+nobTtkRQugrqUYHxBdVTv7+SB1tRBj1HBG0RpTnfnQZOt5zOVAf8o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787672004; c=relaxed/simple;
	bh=BHteRhnSdg7VQ5V6RVG3ngwPW4dm3wGkUrKlCQUQjGQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PF1iSnHXBJNccWO4+K/0ucjGDWJitkZKxXX4+F92IiqdEirdftPsjvRxiSLxGZV5/dI3SNzWsaVd+M7jo2d/yWMBp0pAubNL/BD1AmileFw6NZJHgpErfj+hY9mWgwIspyAEVVmAKgHLCYU8iB3ak1gA96m4PVqZ1UnAEhxt1rQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hhmgB4hu; arc=pass smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hhmgB4hu"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-84e507b079dso3157349b3a.0
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 08:33:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787672002; cv=none;
        d=google.com; s=arc-20260327;
        b=KQgBHuoSLqNH98vOnT20fTnzC8gJSIun6csnsIDXf4nPtH3gfpLvNSa1zJSRY+KnWC
         iD1/e7WGg2FYZ/prkFPfOGkoK5yv8EL6TK3ncC4RsM+ddQ4e1QKWorlftJei6L59zFDe
         nm1UJnGVrF3gqcr6vYz4fHWcOyS+idGcIhq+k3f3MMJbL9kKI3Tug/k8AsPZUurcuF3S
         OtkXLSTSWHdjr44m87ugAAxT56HcxCsVaGkm9RHa8SUT7UE7jlsRbdKMAZKmw0Mk6ZuN
         /O4m5kO32chMLzaa+Q6KWsYLDWRb3MoO2/916cGAQxtv1EJYzAR/skooba9YdC22kuvq
         BCAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BHteRhnSdg7VQ5V6RVG3ngwPW4dm3wGkUrKlCQUQjGQ=;
        fh=TwupXWjUyNHO3ptd00DNeXpBU83k795bhYozM2RviXE=;
        b=RgnoqyMEPbE/HSdQ4wzKzPQCJVnPu6l/i3avo1r+T/rm1ta/3cIe/7hrVFVVmC0hgc
         jPothHKRfQccRfMIXu8xRRDHYuCJKS9fk+Dsr0Nx8ikMigc69CQHLdPTFUrxhYeno1GW
         pQ+dzQsdlN3oyCbx5dzN6DuhtQlDksIWgiOfIF34StZsDYn5u+NBUBCCg6TLH6nFWUXE
         n9uuaVEkkmULaIVT9pm9sSkbUaA21kHGHkd3IJY1LO74r+SbJ6rSgZPYy+9LbjXqq/RB
         KewK1BYdrCY1Vpl4mjDH7SIs0i4k1kvX37/+vUxYTatch6wTzIHAXnevpinzGEUrwj8p
         V54g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787672002; x=1788276802; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BHteRhnSdg7VQ5V6RVG3ngwPW4dm3wGkUrKlCQUQjGQ=;
        b=hhmgB4huB+Ty+Bj6yCBD4JaUdT965Oj1oV3gU/4ZOxSSFRP2kW5XBuRyLCeh/qoj2Y
         AvDKqJGzL11HwVTBuP6qd01NPIQKdVvAX8I3JUWjmA2r5LLidp8a7lTR9KaC5DLNQvKr
         9DTJ7NHrwxvSA2BWFRyQN75aQWUFweYXbX/VS+W0J07u121CJdi4AcFjWFP+2ZkVSErP
         7xG123KV6SduqyaROQX898ONyDxPqphuntFbIGZlcCaJruDjRhwyQY0WVXq/lOJ8SJF4
         RiKooyMhVRw2taAqPAarYkP+SOjLxpvhlOlsoXLIIMooiiVirj3KF+I45bRcw01x3NwJ
         cQ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787672002; x=1788276802;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BHteRhnSdg7VQ5V6RVG3ngwPW4dm3wGkUrKlCQUQjGQ=;
        b=H8MMh15D/x6NhIwL+Bf7DdKZh0XHR7dleiNTgKIbRwqSdQgC9Ewp98yeNdOsmGVwqI
         JAOhb8V0/kMDleLPrILmbUMr1pix10zGw4SuuJHWzzEjcz+bLxlnIGqvZUawfm97nrVs
         bu+JIledv88wimErR8wRm3vFp2FbolrQSYMkclwv3hU90BbzGawNdc2nFCx/e29NMr7Z
         2lWmJtXiU0k7beAqNZVsSJK7oq6oYbAY18l+orHNw8kpmJLLQJr3DVm1uyM/ZuQogIVx
         qxmphU3NX5kve4u1+Awzv5ylQs2AAekIXMyuhCPqVI2AHIn6rSWmdhvd/iw/h/rK0LCa
         J42Q==
X-Forwarded-Encrypted: i=1; AHgh+RrnPrCzCDS6ag3VKP2sGMotjjwEz2yD9DAJVbM1jwyN9zPNZJz+rsjrDjVjDKeU4haOMPmOy+/IjarvUBLxMQ==@vger.kernel.org
X-Gm-Message-State: AFuF++mw1Xc4K60db+itHHPBKU0RGTFKgCRuaVj2Q6wnA+TyeMTW53Hx
	hzk9UFlIU2X1o1zYOrdmRqsoqF4FsnhY2yNwu6BBg40UuBSejcMW5gOj2Yv5xPfY/xezskTxdmB
	/l1a428H84PbDXxtTDwiBug2MHmKb4MIpeGQjMAI=
X-Gm-Gg: AR+sD136bqIAM/+PholXdOdv+WCXtJjWA3aunTlsoAqFcQKXLtdXG+Y7lY8Wz4uRgFL
	QuFUYKOXV+ewz387gG1BVYCKT/8zUV2ppDDqLZuyaExsU2xZ1wIC40yS7V2y+mUzo7X1juyp39/
	IxE2cKWKCOIjFNJfmyScbnHB4mNqV3T+PnovI+n4AOxKff0l0u4t2XCRmJtCNmbeR6AsQZQVszi
	7tAlPswhFYoZz+QHb9/PxD2scKd8ApI6MabKBzOAKyX+IRdz3vqqv3eDgjjsVuJNoXZbdg3+d78
	m26vBLQn7ImOXTJp8dcmeR2PAoq7zsniHVkDzRpmyp9DRR9Df1XPC0u4jWw=
X-Received: by 2002:a05:6a20:d52d:b0:3cd:602e:f8ab with SMTP id
 adf61e73a8af0-3cd90fbdaf4mr16733524637.4.1787672001866; Tue, 25 Aug 2026
 08:33:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+kcdF5BtM9dZJ6JNAvvsTfFZ18xcio06iSsYHGY4S7xDjtZ2A@mail.gmail.com>
 <2280a747-03d3-4468-86c6-6fdcb2154285@oss.qualcomm.com>
In-Reply-To: <2280a747-03d3-4468-86c6-6fdcb2154285@oss.qualcomm.com>
From: Omar Abuzaid <omarabuzaid587@gmail.com>
Date: Tue, 25 Aug 2026 11:33:10 -0400
X-Gm-Features: AcwNN1W7CpmZdBu43DeWr_KvDX_jXo7ly5_7Mk7h-NIXJyJxRU7H_DjiVA_0Xds
Message-ID: <CA+kcdF6xm0ciV2ET_0q3kg4GFFSK513m965C1DX=wKbcHH3vLA@mail.gmail.com>
Subject: Re: ath10k_pci: QCA9377 hard lock on resume from S3/deep suspend
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the guidance.

I created the upstream kernel Bugzilla report here:

https://bugzilla.kernel.org/show_bug.cgi?id=3D221921

I also have the Fedora report open as Bugzilla #2523243.

I included the system information, firmware details, reproduction
steps, PCIe/AER errors, and the kernel log from the failed
suspend/resume.

Thanks,
Omar

On Tue, Aug 25, 2026 at 10:36=E2=80=AFAM Jeff Johnson
<jeff.johnson@oss.qualcomm.com> wrote:
>
> On 8/24/2026 11:41 PM, Omar Abuzaid wrote:
> > Qualcomm Atheros QCA9377 using ath10k_pci can cause a complete system
> > hard lock when resuming from deep/S3 suspend. During the failed
> > resume, the kernel log shows repeated PCIe AER Physical Layer and Data
> > Link Layer errors involving the QCA9377.
> >
> > Unloading ath10k_pci before suspend prevents the problem.
> >
> > System
> >
> > Fedora Linux 44
> >
> > Kernel:
> > 7.1.10-200.fc44.x86_64
> >
> > Architecture:
> > x86_64
> >
> > Kernel taint:
> > 0
> >
> > BIOS:
> > 1.32.0
> > 09/03/2024
> >
> > Suspend modes:
> > s2idle [deep]
> >
> > Wi-Fi device:
> > Qualcomm Atheros QCA9377 802.11ac Wireless Network Adapter [168c:0042] =
(rev 31)
> >
> > Subsystem:
> > Dell Device [1028:1810]
> >
> > Driver:
> > ath10k_pci
> >
> > Problem
> >
> > When the system resumes from deep/S3 suspend with ath10k_pci loaded,
> > the entire system can hard-freeze.
> >
> > When this happens:
> >
> > The system becomes completely unresponsive.
> > Caps Lock does not toggle.
> > Magic SysRq does not respond.
> > A forced power-off is required.
> >
> > The kernel log around resume contains repeated PCIe AER errors such as:
> >
> > ath10k_pci 0000:02:00.0: PCIe Bus Error: severity=3DCorrectable,
> > type=3DPhysical Layer, (Receiver ID)
> > ath10k_pci 0000:02:00.0: device [168c:0042] error status/mask=3D000000c=
1/00006000
> > ath10k_pci 0000:02:00.0: [ 0] RxErr (First)
> >
> > pcieport 0000:00:1c.7: AER: Multiple Correctable error message
> > received from 0000:02:00.0
> >
> > ath10k_pci 0000:02:00.0: PCIe Bus Error: severity=3DCorrectable,
> > type=3DData Link Layer, (Receiver ID)
> >
> > There are also ACPI errors during resume:
> >
> > ACPI BIOS Error (bug): Could not resolve symbol [_SB.PCI0.GLAN.GPEH],
> > AE_NOT_FOUND
> > ACPI Error: Aborting method _GPE._L6D due to previous error (AE_NOT_FOU=
ND)
> > ACPI Error: AE_NOT_FOUND, while evaluating GPE method [_L6D]
> >
> > Steps to reproduce
> >
> > Boot normally with ath10k_pci loaded.
> > Confirm the QCA9377 is using ath10k_pci.
> > Suspend using deep/S3 suspend.
> > Wake the system.
> > The system may completely hard-lock during resume.
> >
> > Isolation test / workaround
> >
> > Before suspend:
> >
> > sudo modprobe -r ath10k_pci
> > systemctl suspend
> >
> > With ath10k_pci unloaded, the system resumes normally without the hard =
lock.
> >
> > After resume:
> >
> > sudo modprobe ath10k_pci
> >
> > The driver reloads and Wi-Fi reconnects normally.
> >
> > Simply unloading and reloading ath10k_pci without suspending also
> > works normally.
> >
> > PCIe information
> >
> > LnkCap: Speed 2.5GT/s, Width x1, ASPM L0s L1
> > LnkCtl: ASPM L0s L1 Enabled
> > LnkSta: Speed 2.5GT/s, Width x1
> >
> > L1 PM substates are enabled:
> >
> > PCI-PM_L1.2+
> > PCI-PM_L1.1+
> > ASPM_L1.2+
> > ASPM_L1.1+
> >
> > This appears to involve the QCA9377/ath10k PCIe resume or PCIe
> > power-management path, although I cannot determine whether the root
> > cause is ath10k, PCIe power management, device firmware, or system
> > ACPI firmware.
> >
> > I also filed this with Fedora as Bugzilla #2523243.
> >
> > I can provide the complete previous-boot kernel log and perform
> > additional tests if needed.
>
> Please see:
> https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath11k/bugrep=
ort.html
>
> Although that is an ath11k link, the same guidance should be used for ath=
10k,
> substituting ath10k for ath11k where necessary. Having a Bugzilla record
> allows the issue to be assigned and tracked.

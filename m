Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B56130D418
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 15:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784300843; cv=pass; b=uiNUNrb3ARr3XtnnPhq6fBf+bK8PTvo06ClD0nGTEJlVdVJeEBZtdGMxVQYHD9C4scaOLLgyzfGhrw7hCJamCQGdFNUcpOV9ZQYICQrrUHoctlI3hVfhBrdmhMO7yhLzF7pr97Jata/oW+Ixw4GQHIXi7OgCS7JjRvBBfPh4NQs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784300843; c=relaxed/simple;
	bh=VlbLFjMrzmDXpu8ToEIqn/yuI50jhB/xC+OsMYiXBH8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=uuWC6PqBvYwPkp3y0A3cPyNx1pB9WOxr+IHreflwuIMCwHyHP10szphDK0jbu8KsfakczFD69iJGGHTch9fBiPY+ZjKk0GZZH8wqLRGEUBiT1EwzToIyDgOUjZfKsywJEuF43qWcNG4NKguC96huti3QWKF2Y6aKIpWHNHE4njc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=q8WldA/0; arc=pass smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q8WldA/0"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-81e86df8987so23272187b3.3
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 08:07:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784300841; cv=none;
        d=google.com; s=arc-20260327;
        b=O3bhufACHGnZoXTa9cufslMGmAfYQa3huvIhKWlMmFCndTLLIwmdmoWugWdtfR4LNw
         5/MHLRhvEXzRY9L1UdHufG/XpLA34Dp4mnjfmMS9bEfePLzuoqHJ7vpGRMkjMlS9h+10
         ZeEPW4AJMBzbAZIu8a7X6BuuEKsyWm92lAAcySCYWHxfB/qGuEWG1bYEdQbKTa8buxI5
         dcfzZGGWtEVZEIHUVJe/w7R6atV4OnhPi1tjqDB52khw/8TyaxOqJOisDD8GWEIZF+sz
         HOkBrAr4yED2NMzMoMKD7lwJBlDlFsEdo4g0e24cHLvcjiwa5YymudouRFLuUnJVUOgh
         njfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=VlbLFjMrzmDXpu8ToEIqn/yuI50jhB/xC+OsMYiXBH8=;
        fh=vvUk1b7obilBMi8zDq4FdsebZKZh9tGB1t1FOSfp8hk=;
        b=ZlA8kUXHGOKggEnaRL2rRiLa7VwgCdC3Q+lXkd/73BC0c/j8597vmDwC91/gJGMX7m
         TsYQ+lUOc7EJSibVZk51WZzQDgLZawTzMJpN6qbfnkjJnRRWjKuolU9XWX8T398zcLYj
         juOfZdw872sBR4DoprU+hje34zZdjnzfP4xGl4+noHcGxXwqYEtqMeJPfPq951QQFVS9
         IC5mGzKLJMq8iIzAjMQFCfu486gGx7MLUOWliFosEp3PFGJ152VhvpoPHmrD7SUlGErM
         LN/zCpbbnYzURfm6cWmkO7MiU9xk2MmlL36rQQbu0/3Ktfp+f21vmYdbl3shio/qOUtQ
         BbZg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784300841; x=1784905641; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VlbLFjMrzmDXpu8ToEIqn/yuI50jhB/xC+OsMYiXBH8=;
        b=q8WldA/0RQlVUbJ/ckvZGkOLnDSRrtcFLdP7ronABXZC61JuYbHqMEvR5USfVy3iHQ
         wiHuNilOKgusEPON1eJYU6cH41ivIkyfktWZogX8ePuAvlxgcqqCF7oyWNxb2XYvWDZL
         oBoMnxbIPeHfOfhiJpwmauCVNZNzK1JBmtXQk8XkMorNLRnfx6UnTYtPxdJcgjYBICU1
         SIxsxr7LMsXmcngYKPYpW4U4Wu7Sg7v++q0wF+awIjSdfBjQOvdB3DNCLgcMdJzIsyyK
         jvWKU6l1swk+L9XqE6F2ct9OBjJaYnwWEtriDaYdf1lOr0Y7Ze/Az1bqrCbMJbl7DGYM
         10lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784300841; x=1784905641;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=VlbLFjMrzmDXpu8ToEIqn/yuI50jhB/xC+OsMYiXBH8=;
        b=BXI2x6xRQfPdkhw8f4wj7TsAytfV/g1fllT8SAqxOLG6oyiBlsrjXnWdvhP1PBBTKR
         41eibIhFSQW2NvZwBif5byuFUiLfFCC5LaKkPp/uA1l8GRakZ0N9ZN67fLPixyBFQMYA
         ypGWdT46iMm0Eyn+h9MkV4T9JfcmmEcgk3YNnR3biRjzsIVOXS3Lq1XTjyUQh8BWOEpU
         u5ttoWSlNkrqGnqU5hW2AY6PD2d/Cw0Suae1KXkCDjpaOT64oIGnYzfi243/YnHNddQq
         BfIdTOmdMa3Zl0/V9Xo9ineT4AZXEeAY6FHDIRaYKhPYPLqpeLG+S7GWn4i0MU2u0LS1
         9Vrg==
X-Gm-Message-State: AOJu0YxSJAWwwcprM7LTulO7ATemS2G2aR5dVm0hklLEew9KvQ/xFkNz
	97s7oz2ZrDAg+sq9z2ONd26XyemgNrgcKbNUTMlTCZWUDm0bWjSzYvHSe6TGDfq/iqEHUPkV6K4
	lbCZRO+Evm9K5w+ESG42vCJzTl/JGT0u+p3hO
X-Gm-Gg: AfdE7ckEtVjAiKVBxqRHPyKSR2L6lxavJpqaXFBY903kO4dKhfepneTT9k05H0/Fppt
	bGekqe2At+ML+AcG80Vo6f+8K9M+dGkJyISAN00NutGZNn1OA0qBnenu54MYXlFWsvK1vkAIZm/
	Lhkp3UyounSFS4O9+LyfKST+lpOWsSuRkDlZirT6VTjgtXXuGEfySuXF/2DKp0AQ3rQIcTApdm/
	B4iIW5XFkX1T1tuKywiBkwJKR0BJAlycTNsEzXIgWsc35RDB3MmN7q0v/9bGB0=
X-Received: by 2002:a05:690e:484e:b0:668:2343:f9a9 with SMTP id
 956f58d0204a3-6683bda79f9mr625965d50.93.1784300841058; Fri, 17 Jul 2026
 08:07:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?Q?Micha=C5=82_Wi=C5=9Bniewski?= <wisniam86@gmail.com>
Date: Fri, 17 Jul 2026 17:07:09 +0200
X-Gm-Features: AUfX_mzKtUXcRdD_-KWVL1IZ8Cly2QJri0IN_TFmoPdTiMdfWRdDS6lr-7E6FYQ
Message-ID: <CABcniwq7R7=gvCdCrV+1mtJhKhhee5ovN9RqNCO9ySoaBcoiCQ@mail.gmail.com>
Subject: [BUG] mt7925e: MT7927 stuck in D3 after VFIO guest reboot
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name, lorenzo@kernel.org, shayne.chen@mediatek.com, 
	deren.wu@mediatek.com, linux-mediatek@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,
I have a MediaTek MT7927 passed through with VFIO to a Kali Linux VM.
The card works normally after starting the VM, but running systemctl
reboot inside Kali causes the VM to hang and the physical MT7927 to
stop responding.

After the failure:
PCI configuration space reads as all ff;
lspci reports Unknown header type 7f;
FLR and secondary bus reset do not recover the card;
QEMU remains in D state even after SIGKILL;
only fully disconnecting AC power from the host restores the card.

The main host messages are:
kvm: vfio: Unable to power on device, stuck in D3
pcieport 0000:00:1c.0: retraining failed
vfio-pci 0000:02:00.0: not ready 65535ms after FLR; giving up
pcieport 0000:00:1c.0: Data Link Layer Link Active not set in 100 msec

Hardware:
MediaTek MT7927
PCI ID: 14c3:7927
subsystem ID: 105b:e104

Guest:
Kali Linux 2026.2
driver: mt7925e
linux-next tag: next-20260716
commit: 1a1757b76427f6201bfe0bf1bea9f7574f332a93
uname -r: 7.2.0-rc3-next-20260716-mt7927-test

Host:
Proxmox VE 9.2.4
kernel: 7.0.14-5-pve
QEMU: 11.0.2
driver: vfio-pci

Regards,
Micha=C5=82 Wi=C5=9Bniewski

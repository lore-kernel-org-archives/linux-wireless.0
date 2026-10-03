Received: from mta0.migadu.com (out-133.mta0.migadu.com [91.218.175.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1E8233924
	for <linux-wireless@vger.kernel.org>; Sat,  3 Oct 2026 14:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791036925; cv=none; b=rSWfgkgIDpXhv2VMIkswEzWH3LEe2yzF0UrXsFVFuZj+nSbPKBDfII/6itUEPYT5AA0v0/e3mk2+Rd7lOZsRcl+A9aN5gkO/tMY/eDOxKrbZzGeGFUD5ZbmB/iDhD8yISBwcBqgLWRZ6wS+n7jVDD9BVp2T41MOGirRthgxvN6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791036925; c=relaxed/simple;
	bh=Lim7ebmFMwTXYrEwVAlmyrqEkkzaoDrtowdpPV/lfyo=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:
	 References:In-Reply-To; b=Mkwj40fUQJIdDNbEt792IPP7WfPSwF1JKoRVaLwFr9vdyhJCmXhrTF9YU7xLpc0xC4e2g2V/Qgb42trSDxEjHdbM1RTJJ/Quem9SrEBv3lIF92I+EMHQ0OgiIW3Su8/Y4O1IbEGGcsI8ttQFeohB5UDXvAbAQ9UrsOJ4cFAR46U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pfQQ0BzC; arc=none smtp.client-ip=91.218.175.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pfQQ0BzC"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Lim7ebmFMwTXYrEwVAlmyrqEkkzaoDrtowdpPV/lfyo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791036918; v=1; x=1791641718;
 b=pfQQ0BzCWHCNsIRstVK0vaFr2/vtRVdl6vxqdu+Lxenizk2gVPHPC8Vz3K3dwZzbcpgkqo6K
 z/asie3NVbiTuY1anf7hoZJUkSP/9LHeOdarDPbZgZOCZW5FPTZm8BLGdpEWQnXDNZbXRTPIYOE
 6RZEgZRSfaFB98gIHvQKuKH4=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 32adeaac776b1456;
	Sat, 03 Oct 2026 14:15:08 +0000
X-Mizu-Trace-ID: 32adeaac776b1456
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 03 Oct 2026 16:15:06 +0200
Message-Id: <DLV9LG0TJEV1.1A6NUATG6Q2RH@linux.dev>
Subject: Re: Problems with rtw89 on 5Ghz wlans.
From: "Luka Gejak" <luka.gejak@linux.dev>
To: "Bitterblue Smith" <rtl8821cerfe2@gmail.com>, "Ping-Ke Shih"
 <pkshih@realtek.com>, "PierluigiFrullani" <pierluigi.frullani@frumar.it>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <10543730.tdPhlSkOF2@topolinux>
 <fab16229-8e70-41a8-83f3-5d04c6035a43@gmail.com>
 <980970f8b4934572aafbd6f5f6020436@realtek.com>
 <dc900baa-a3c7-4962-a11e-9a949af92340@gmail.com>
In-Reply-To: <dc900baa-a3c7-4962-a11e-9a949af92340@gmail.com>

On Fri Oct 2, 2026 at 7:02 PM CEST, Bitterblue Smith wrote:
> On 02/10/2026 06:44, Ping-Ke Shih wrote:
>> Hi Bitterblue,
>>=20
>> I just quickly give some comments before you send patch.
>>=20
>> Bitterblue Smith <rtl8821cerfe2@gmail.com> wrote:
>>> On 30/09/2026 12:21, PierluigiFrullani wrote:
>>>> Hello all,
>>> Two other people reported the same problem recently. I decided to wait
>>> for them to say if the patch helps or not. But I will send the patch
>>> anyway next week.

Hi everyone,

I just want to make a quick note here, I have the same issue on my HP 255 G=
10,
and that commit at [1] fixes the issue, and everything works perfectly now,
wifi is stable, speeds are great and I didn't find any issues while using
my laptop.

Best regards,
Luka Gejak

[1]:https://github.com/morrownr/rtw89/commit/faad39934e2e23efc0df5c247c3bee=
2be9743b08

Received: from mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F19429037
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 10:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789121816; cv=none; b=o1WnPzXSexPwWxlp5LToJRj67lVtkZtX4haCSwJ9k/0fMWSfEvHOvWtozLQGoX89ZHzvKy3nco5pa1mc8nazZVs5vfY9EOIHVLl3t42EXt4q1+itwKnIizTH46hIZfFyqVWPThapXlvU3b5++lhpt+Qdl+f2bQMI/O1t0VMFFi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789121816; c=relaxed/simple;
	bh=CP942oWEBd47mNJNqWykU6R4vRXGichTQsBF3/85k4c=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:
	 References:In-Reply-To; b=QUmksm560r/BsMqvUY5aTn23aUnKqpSORDUihGLZkcq+h6UVGZ1j2g4YaB9H3IapLgncz5YPVPKhOWZ2LTV3E15YwbqpPe2dYC4GSLYyPn5Z3UuiEbqZ6/gx6QAljcPQm4t/fwn3sH81NUrGobopu0I5s0qNusL1i4Yl4Ppytw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow-tech.com; spf=pass smtp.mailfrom=cknow-tech.com; dkim=pass (2048-bit key) header.d=cknow-tech.com header.i=@cknow-tech.com header.b=AzAKSe3P; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cknow-tech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cknow-tech.com header.i=@cknow-tech.com header.b="AzAKSe3P"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=CP942oWEBd47mNJNqWykU6R4vRXGichTQsBF3/85k4c=;
 c=simple/simple; d=cknow-tech.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789121808; v=1; x=1789726608;
 b=AzAKSe3Pa06YPL0+xFwsQik2GsuO2wq5CYXCQh7HMx5ceRkefqs3dTELqDWaBhdA5ygjm+yS
 KxF8T5NQ3teab46opHapFT0hBes/g8qNaD67ZiQq4+JZ6wnF/gs+t925Zvmwj8Tx7AlcCGDSE4s
 AxhNH3Z9+0PPVd9IMX5QH4nT7/1DmE+6DH0g1nixmOJtaETEIUFA/XU2da/8uVY66XQj3pGSD2B
 s2E7333Dl/r67twLZYXn8Z1s6LD5NeXmwZ6kOLCavMgj6+QQljzpTSy+QC64JBr0KfzoSQuyPYh
 JaOFrbZ9tkrVUAu5h91pmTqpU86D8BCvAE7upfX0W4xjQ==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 02437128f31cb33b;
	Fri, 11 Sep 2026 10:16:48 +0000
X-Mizu-Trace-ID: 02437128f31cb33b
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 11 Sep 2026 12:16:47 +0200
Message-Id: <DLCEQZK5DBQN.2TCHLRZWE5EMT@cknow-tech.com>
Subject: Re: Stack trace when starting iwd with Intel BE200 M.2 Wi-Fi+BT
 card
From: "Diederik de Haas" <diederik@cknow-tech.com>
To: "Diederik de Haas" <diederik@cknow-tech.com>,
 <linux-wireless@vger.kernel.org>
X-Mailer: aerc 0.22.0-9-ge948bb7230f4
References: <DL5P72WYQVOQ.23G9D01OY3BAA@cknow-tech.com>
 <DLBMROQPJN2T.3BIEEFHQ7R6QB@cknow-tech.com>
In-Reply-To: <DLBMROQPJN2T.3BIEEFHQ7R6QB@cknow-tech.com>

On Thu Sep 10, 2026 at 2:21 PM CEST, Diederik de Haas wrote:
> Not very impressive Wi-Fi speed, but alas.
> I actually bought the BE200NGW and (later) AX210 card for Bluetooth.
> Both perform poorly/terrible on that front, while the Intel 8265/8275 car=
d
> in my *amd64* laptop works great, including Bluetooth.

That turned out to be a HW/PEBKAC problem: my pigtails were broken.
Replacing them resolved my BT problems and Wi-Fi performs (even) better
now. The stack trace on the BE200NGW is still present though.

Cheers,
  Diederik

Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B8539C009
	for <linux-wireless@vger.kernel.org>; Tue,  7 Apr 2026 09:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775552422; cv=none; b=TyWShJqZ7RDj86cxvngb1Qae6cxkRvyAi4S+eit7b/dwfBrYaTtn2AYZ3kIfbuvh7XimbGTFznKSeM11VOyOqz6JJ2V6fXg+GFMy34eine6+K22MQ1ILTuNazHdXmKdYUYtq6GRlBKZBZNXf3PJshRiz4scUl6pAKVuPoOLGn+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775552422; c=relaxed/simple;
	bh=f2WNmtNGEMXlUkgNTy9D95aV4k6e9ttfbrumvyiw5H8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=vBfrfFPuCdlB67ANJdHZ7uShmIkN+4Vsj7uMFvElK7BeOoTfNTECdGwTD1qiXgYNqO/CgUeUQbKqZYzoFZ8yUNAPmBtoHUwP38g3FudJ/L9NJRca21CF35im2yhTwS3xdZEK6prGtatHWpXPonx2ypizMM0nvQ2vTTx/F6GRLwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=uLvSChaE; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="uLvSChaE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=f2WNmtNGEMXlUkgNTy9D95aV4k6e9ttfbrumvyiw5H8=;
	t=1775552421; x=1776762021; b=uLvSChaE2IBBXdl/WRPyelb2ZQ2fBCPoPY9B6WeHagle+re
	x2rqewOQbrTKHiHUBB6pFM48ug9JFe0BJkoCrRuEmHnclsMo1WO0nEHDntKLymVr0LBR/1ZhM5I0J
	G7/+BXS+GYShmYF1kuFuwdMid+gVtu9cjikL4bEidwyNSk4S4LgrY+dkuTKJSd7P1CZ5lTDGxbQW3
	LlplqyZjYK9FuIFjJdR+btav+5ZfDtdwB8AhBLlcF0j4GPyU6fnyWip5GLnKwvuTDjr9NMEcGzErE
	77Xx9qfvt4ZvlViT7JnCqjyoFcj0AFa292XKb6NebO3YqnMcvCfecovAP/5GZ7+w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wA2IF-0000000CAzT-1gVi;
	Tue, 07 Apr 2026 11:00:19 +0200
Message-ID: <e492c443eee0918690a842d9d2eaaf23c2126473.camel@sipsolutions.net>
Subject: Re: [PATCH 0/3] EML Capabilities compliance changes
From: Johannes Berg <johannes@sipsolutions.net>
To: Pablo Martin-Gomez <pmartin-gomez@freebox.fr>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 07 Apr 2026 11:00:18 +0200
In-Reply-To: <20260327201135.905852-1-pmartin-gomez@freebox.fr> (sfid-20260327_211151_662542_5A83B71C)
References: <20260327201135.905852-1-pmartin-gomez@freebox.fr>
	 (sfid-20260327_211151_662542_5A83B71C)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Fri, 2026-03-27 at 21:11 +0100, Pablo Martin-Gomez wrote:
> There is some discrepencies between our codebase and the final version
> of 802.11be-2024 regarding the EML Capabilities field. Given that no
> driver supports EMLMR or tries to use 128TUs transition timeout, those
> changes should not have any real impact.=20

Heh, funny, I noticed this a while ago too - it must've been in an
earlier draft. And UHR has the same - but *does* (for now :) ) define
128 TU (which is why I noticed it.)

johannes

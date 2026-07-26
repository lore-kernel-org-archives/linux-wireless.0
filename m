Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04950367B74;
	Sun, 26 Jul 2026 19:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785094686; cv=none; b=Baw6P+pFI/0DSuPYQPZcTsL28cI1OwUtOQzmnIl5uvWwDDj2RYp9/10tBX2C5LB6g1rhkQwI34oU7oTI3RliTVjF/bZjVKmqgOKYFDjVlAWFT0N+DFHbtnkeY9puJIyYSozlPg3wNWik7gjryq6pIulNaaWpYpoFX2wLek6JXUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785094686; c=relaxed/simple;
	bh=edzF24OggSNd+Np4UlPFpu3NEGTHhVPlajLLhzFF/zM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=I7F4AykP7xjoJKCyZdH8nEctp3Np1AeELyyI1fMti1lL3AR7MLLOCX1BfEBRMezDybODBQGkBGyPFJmv4Te38qsOSjw4xGd4tNlXNRG+OHG/MyLHGsf+JralJWveQGhVD94qoxZR2V5ixaVVqGOU4R/zqfI6Qf3cjQyDOpl+shc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=UIfG8N14; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="UIfG8N14"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=edzF24OggSNd+Np4UlPFpu3NEGTHhVPlajLLhzFF/zM=;
	t=1785094685; x=1786304285; b=UIfG8N14v8YzBo28gsDRjUUXKHiWaX5Aarxjog2GMUuJII8
	2MeB5b/X6DNqgsLzg7ntzrW0bmzmLSbZ6/ctAilVkC5my3NNAQeD4Ylp/4jSETPq5AyvdVLFJJcis
	cVjGQ23Tg0Xm//UatdC4McyYDo2Mu5CsVN0UPpUF3u1bU2+LhASf6akq4fPr1gwLeVfkhbrBZAN0/
	dcg8bRyDGPAco/JdpjI3pKRugYISuEKBuPqKB5pYbmgUidhpLtW/6uyEdMDTLv9IxxAy0LePKlP9N
	KKiKueczSUa30X24ljvJK0TI/xd3Eq5mDoI5eo3iB8O6Ojip6WyV4hh6D65Jn8eQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wo4fh-00000004FWZ-0eBs;
	Sun, 26 Jul 2026 21:38:01 +0200
Message-ID: <78e9e3c667a7e356cfd2f736fd5852c91bd7cbf4.camel@sipsolutions.net>
Subject: Re: [PATCH -next 10/10] wifi: cfg80211: convert cookie output to
 input parameter
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev
Date: Sun, 26 Jul 2026 21:37:59 +0200
In-Reply-To: <20260726192541.2816743-11-arend.vanspriel@broadcom.com> (sfid-20260726_212621_952206_40730C54)
References: <20260726192541.2816743-1-arend.vanspriel@broadcom.com>
	 <20260726192541.2816743-11-arend.vanspriel@broadcom.com>
	 (sfid-20260726_212621_952206_40730C54)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Sun, 2026-07-26 at 21:25 +0200, Arend van Spriel wrote:
> The tx_control_port op is excluded: its cookie pointer is nullable
> (passed as NULL when dont_wait_for_ack is set), so the nullable
> pointer semantics are still required.

Well, kind of? Since we guarantee non-zero cookies, we could just pass
zero for this case, maybe that'd be nicer here?

johannes

Received: from e3i345.smtp2go.com (e3i345.smtp2go.com [158.120.85.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71DB3563F1
	for <linux-wireless@vger.kernel.org>; Tue, 17 Feb 2026 15:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=158.120.85.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771341155; cv=none; b=UekhpJSPQNmbMkEu00qNEC1aDi5C4vonRjNlkcYREyy3RkPJ6uJxp4hIfKaGcKur8DAPp7Q3sb3+3UPyAdzxST67wrr/eZxUyGCV6gvCYOGD+YeARFG0goeQ+mJHJg48wieVOMjLcfP8AWeWiemv5ZmZb8NSb+Giaxz7GwKVMHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771341155; c=relaxed/simple;
	bh=OhWAz+jabBRNv8FmcjzBJ7aMKGs2tDl/ObdVALZP948=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SadJTQ/i9gcEWMJa7VoiH1mv27osbqNKtRgG/3DzOcPSDw5Hl6d4Kzit4q1rVzXOoE9EdyxBNgMhcBoi9SqWnb29OG7RSW+70x37x7oRh/Ccik+dRJu/dfsvzQD3IsDlj66lqpPINHT6rhXxhpXuRKMCajHAM0EeYsA2FrS+dtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=triplefau.lt; spf=pass smtp.mailfrom=em510616.triplefau.lt; dkim=pass (2048-bit key) header.d=triplefau.lt header.i=@triplefau.lt header.b=L+qHGYGe; arc=none smtp.client-ip=158.120.85.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=triplefau.lt
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=em510616.triplefau.lt
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=triplefau.lt header.i=@triplefau.lt header.b="L+qHGYGe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=triplefau.lt;
 i=@triplefau.lt; q=dns/txt; s=s510616; t=1771340240; h=from : subject
 : to : message-id : date;
 bh=p0B+jzyEc/evu9YXwaZWRaOjDAOATYrIcofUHcDd/bs=;
 b=L+qHGYGeIlyRavFO0ocSlrJ9psE+RF5vTAc5f3w4a1t0m9kjeJrX/bjZU31gvtyG9obte
 allis6NYFz7b48gaK+VkCHfXXI1NvFSJW2awLqqJ9Xv22JQybQTlk1K0i7iYghwlmkPN15A
 A1dWF2lv0LHF8UFgwAGeRugCmEQdLVnOtDeDYPIYuWctwXrWufQnpg9VtqPeGdf9etSV4yJ
 8ypqKV7Ou8GKzMkkwWizkDsoxjwnwKFs1Rsnz9wlxrpGH7YWWG4Wf+4oDrEsqkKbSWbPq0X
 zU8paS3IorsPmPx6YItdVNyj+z0lXtmdboOXsWSmSBqma0z2CO4PGb43gCEA==
Received: from [10.12.239.196] (helo=localhost)
	by smtpcorp.com with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.99.1-S2G)
	(envelope-from <repk@triplefau.lt>)
	id 1vsMVt-FnQW0hPqt1q-nivV;
	Tue, 17 Feb 2026 14:57:21 +0000
Date: Tue, 17 Feb 2026 15:38:49 +0100
From: Remi Pommarel <repk@triplefau.lt>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless] wifi: mac80211: Fix ADDBA update when HW
 supports reordering
Message-ID: <aZR9eQlhy55iD6IN@pilgrim>
References: <5806bab7e46506d3c300ab4eb66989d42936aeb0.1771323902.git.repk@triplefau.lt>
 <f1243e86eea72999581d33c6f97ff9015ce71542.camel@sipsolutions.net>
 <aZRnlPA_uY9uWuKr@pilgrim>
 <d142f76473a03c76c780390f0352ffbb03566e48.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d142f76473a03c76c780390f0352ffbb03566e48.camel@sipsolutions.net>
X-Report-Abuse: Please forward a copy of this message, including all headers, to <abuse-report@smtp2go.com>
Feedback-ID: 510616m:510616apGKSTK:510616sbru8S-D2W
X-smtpcorp-track: uThcMqhl0AFt.VMhAYc_szFiq.2wdgswDCx1k

On Tue, Feb 17, 2026 at 02:59:34PM +0100, Johannes Berg wrote:
> On Tue, 2026-02-17 at 14:05 +0100, Remi Pommarel wrote:
> > On Tue, Feb 17, 2026 at 12:30:08PM +0100, Johannes Berg wrote:
> > > On Tue, 2026-02-17 at 11:36 +0100, Remi Pommarel wrote:
> > > > Commit f89e07d4cf26 ("mac80211: agg-rx: refuse ADDBA Request with timeout
> > > > update") added a check to fail when ADDBA update would change the
> > > > timeout param.
> > > > 
> > > > This param is kept in tid_ampdu_rx context which is only allocated on HW
> > > > that do not set SUPPORTS_REORDERING_BUFFER. Because the timeout check
> > > > was done regardless of this param, ADDBA update always failed on those
> > > > HW.
> > > 
> > > Seems like a legit problem, but
> > > 
> > > > Fix this by only checking tid_ampdu_rx->timeout only when
> > > > SUPPORTS_REORDERING_BUFFER is not set.
> > > 
> > > that doesn't seem right? Especially the way you implemented it, it won't
> > > even respond at all when it's an update and SUPPORTS_REORDERING_BUFFER
> > > is set.
> > 
> > I could be wrong but I think the patch format here make it difficult to
> > read. If it's an update and SUPPORTS_REORDERING_BUFFER is set, the
> > following "if" in the code (not fully visible in the diff here) will end
> > calling drv_ampdu_action().
> 
> Yes, but it will be IEEE80211_AMPDU_RX_START which isn't really intended
> by the state machine/API between mac80211/driver. So that doesn't seem
> right.
> 

That does make sense. However, if I understand correctly, it means that
even if we end up storing the timeout for drivers that support
reordering, a new IEEE80211_AMPDU_RX_UPDATE should still be introduced,
right?

-- 
Remi

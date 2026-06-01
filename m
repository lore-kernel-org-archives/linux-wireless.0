Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5158C3905F0;
	Mon,  1 Jun 2026 09:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780305965; cv=none; b=FFYKKM09lnskucdTzy9MUfZ7JEZTjGCIabLlyIFvBhawW/zO8BgMhzi4CCRKPGuPgexq7FJqyaFRMzupUKr6pGBeh0vxNhR9lWIOhMfS+jHFq0fYTW23hl5NrkFlLQF+81Yeg+j8B1hUTM+xFrYkjjhmJ7k5L/KAiVJ683HShSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780305965; c=relaxed/simple;
	bh=mJmdD0LLbKLviy3dAzYdFEnkU8pz3pWcFotGf6KErwc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oqgBk92VaM3zjiqLRiNybq/53AsZU7uJvac5PeNHAShJvzUwJNUFjHi/WBrhLiu+PkqVxUkdJFT2H9b3bpNzIESf/+d0q0EcelMO7CX3ud3F9fowbvvIZQJ3561CJ1Rl/VDD3TW/e7x4UU1n84k5QX1v52KdfHUUhe9tnO81nU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=GQHW905D; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="GQHW905D"
Received: from localhost (unknown [10.10.165.17])
	by mail.ispras.ru (Postfix) with ESMTPSA id 86DC245F79A0;
	Mon,  1 Jun 2026 09:25:53 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 86DC245F79A0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1780305953;
	bh=nwVe4teaBzPyB6XRW5wIjXR8sPVlK8O7PAAUTmQD9bQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GQHW905DL1F8H/egmgcOK158hpxM1QniHC7N2Pqz4xS+PA8FtPUM8nPU8Yh1CHl9B
	 TCnxbWi7sC6ek3khy732ZOnzC4nSx3536EryOLfArYS1mUJqHp2PSN6aQt7HbfPljs
	 qsiSeZgV2YAed2XHa2tprfEkC28bmFtuDxUXdP2g=
Date: Mon, 1 Jun 2026 12:25:53 +0300
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Tova Mussai <tova.mussai@intel.com>, 
	linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH] wifi: cfg80211: fix leak if split 6 GHz scanning fails
Message-ID: <20260601120655-7baca21ecc1b4e1b8a19104a-pchelkin@ispras>
References: <20260524165320.62089-1-pchelkin@ispras.ru>
 <21b5dc35ef16217adce0ef726a603a11951da4d2.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <21b5dc35ef16217adce0ef726a603a11951da4d2.camel@sipsolutions.net>

On Thu, 28. May 10:42, Johannes Berg wrote:
> On Sun, 2026-05-24 at 19:53 +0300, Fedor Pchelkin wrote:
> > 
> > @@ -1101,7 +1102,12 @@ int cfg80211_scan(struct cfg80211_registered_device *rdev)
> >  	rdev_req->req.scan_6ghz = false;
> >  	rdev_req->req.first_part = true;
> >  	rdev->int_scan_req = request;
> > -	return rdev_scan(rdev, request);
> > +	err = rdev_scan(rdev, request);
> > +	if (err) {
> > +		kfree(rdev->int_scan_req);
> > +		rdev->int_scan_req = NULL;
> > +	}
> > +	return err;
> 
> Given that rdev isn't accessible to the driver call in rdev_scan(), I
> think it'd be nicer to do kfree(request) and defer the int_scan_req
> assignment to after the rdev_scan() call?

It would differ now (at least visually) from the similar scheme used at
the end of cfg80211_scan_6ghz().  I'd go for that all this request
initialization stuff should be done before calling rdev_scan(), taking
that rdev_scan() may be changed in future or whatever.  But I don't have a
strong opinion here - will send v2 so that you may choose the eventually
preferred one between these versions.

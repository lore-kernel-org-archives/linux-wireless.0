Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60EC3002CF
	for <linux-wireless@vger.kernel.org>; Fri, 12 Jun 2026 14:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781273270; cv=none; b=RNnM3169RqrlxSTIdYnuPGgMCfk7tIU/ehzz4VDLWjZ3VvqdBEWdJy+IAEYJz1ZmmtbMEuGXyA1P1l3e5qRbWlZk6lR73hydjuIWmggoQ/lXPW5t9f5fiVCT0C44IvEvfpPTx7sGdlTldR70JiVqvQ5ygL4ozM7bqFHNd3wX6iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781273270; c=relaxed/simple;
	bh=btjPbNSUbabKku1c0RBU7ZGV4LpOUhL43kNK74m0YEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gm5hS0AleHCHy9zPGPtavhnkP2S/WLCi93zpkiu7DUfmrdjt2BGAQLmN0Ze/t/rg7kr3redSi79uuSL2+iG1zIAlRZYHz7CTsOWvs7iURzn81vIclqN0Ybw8ILr7R3OHqsybFPRzKaXWIgIuf/xh8GPkQD+2bGq+4EN2T8gTWZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=sfq6q6ty; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="sfq6q6ty"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-36ba3ea5c46so647009a91.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Jun 2026 07:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1781273268; x=1781878068; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v6XnfIOCWTMr8+cdR8ElwI3mA/tB9ye05U71QzK/G0I=;
        b=sfq6q6tyVYLD1GG0rUxkhV0BQQgC3W/BahgyVusii33yDZYe8gifn5va/nJsnM2fnK
         rHm1seOdL0yoNzl2u829ALNZwmLX1lQfIJpNpFKNrP7xiA0Rt5c1R2QPBXUcw1o9X7c+
         s4ljfv2LkOO7kbF6GSB/2isEYMMTMzXCRsAmnZRSKyA0d+ALJrHt6S8YkCN3R4gDeiPP
         8xKPNa/N96ni8N0zcAwkWFrDW8Ym05h0ZNiDyoWbiGQMsYDHu+SqTqFiOOI492pkhLfv
         5eo+UuC16GVLOHEqsBiU+yt/h4D4SNrzqz44CpOiXCBM2nUsJ62jgljTn//AOQ93JOlC
         cxiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781273268; x=1781878068;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v6XnfIOCWTMr8+cdR8ElwI3mA/tB9ye05U71QzK/G0I=;
        b=Ks0L6hA+VbASYTw41uNnYuqxQdIzdhD5RGoviU4wNWixUqU1C9rDvR1gBlkhx8aNzL
         TLCPERIaJk8FSVgL4bKsPDdwOJZK48pJSaQgs85hvK5vcIXeE1ZIdHFeZXQ6KGcI6BJL
         5kdIQNwh68fJ87eBP+cQcteM1giTanISJSsBplEKuqha6sYbHchDVxWT92U9iBMaW5bg
         76mY9RdT6Vajj/M+0e+Tx66TpD5J+8KzTh8BIBxxE5qh3quv3UfzCOXq+jI7QNg6lfyC
         PfbyEyJEVQlX0nIrXWaWlKhvvadFLKa2Tan5iNqZ2KpeTGFqVSKRWUy2+I08HlsNShSi
         fL2w==
X-Forwarded-Encrypted: i=1; AFNElJ+NWwWuIoZq1mlmk0eo+vgprCdYCo2lGO+mTph1HtiFQPeMGjRMdZ9+BSeUvC7bSnXWIMY1E/T+QOt1CmsX0w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxwfFJWp20LI+AxIsAkrH0Sy0pn+DVYzCaaSXJv4YyYZ/ycJXFj
	u0h0Ym/WZJp1Nn4TdFUXwi+9ZAHGvYOyhZwbzUf0tMhrJOZpj6rFYWirXVDRnmGVvTs=
X-Gm-Gg: Acq92OEom9Fijy+3IIuf6CZLbm9iGOU5AKyfaXngTJUBg40a8cIrdJZcINOZhi7wgR1
	87J7EoWy6Ww9DkuveoJ8bqezDyl2/0+Rz684WvkWSbAGjqa7kw17y0YysEoljLKIQp3ZZ/WmQBu
	ODBqsqUKS/eLaeioBbmbSkSFVqEFPuNYP3uIZhM7P5VgdQ+jbVaT1FonP9dUhrFDm2m/gDl+OX9
	GRsk2U2Qa5dU7H3lpNnDpJUkpht0Kmt16VRGJJ5AGkF+yyZpU8jbISKigmijBvftQzh1XWZZsWj
	fXWCgL5eb9ZCFEEH/aYtyq8/ynpHt+9WmZ4quYR6BufQOGWN7sYHKW9E4NuctAOt0Qt9bYhMKSN
	z/PUPSWiwjaJFHS5VBqhUn8S2+ui7CRDBCjV7o2QxJkADSWwPC1EBOhAL00m+WWhJ6bKwJCRxH0
	CPGgkZ1AcOmS4Fi8iCjDyIaejb4epGmD1p3XMTxV37TEWxZi7jGrVspQMyxvDG+RzM
X-Received: by 2002:a17:90b:4a43:b0:36d:5dbe:2a0d with SMTP id 98e67ed59e1d1-37a02417c6amr3478559a91.7.1781273268174;
        Fri, 12 Jun 2026 07:07:48 -0700 (PDT)
Received: from localhost ([60.227.167.223])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37a237dadbdsm2380476a91.5.2026.06.12.07.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 07:07:47 -0700 (PDT)
Date: Sat, 13 Jun 2026 00:07:44 +1000
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: Zhao Li <enderaoelyther@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, 
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: mac80211: avoid non-S1G AID fallback for S1G assoc
Message-ID: <a6upqc5b7kbemkkeuuzqsueha5toec5fvozeqoj7znosn635te@urjq4kf2bedf>
References: <20260612133649.92630-2-enderaoelyther@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612133649.92630-2-enderaoelyther@gmail.com>

On Fri, Jun 12, 2026 at 09:36:50PM +0800, Zhao Li wrote:
> When assoc_data->s1g is set and no AID Response element is present,
> falling back to mgmt->u.assoc_resp.aid reads the non-S1G
> association-response layout.
> 
> Keep the fallback for non-S1G only. If a successful S1G association
> response omits the AID Response element, abandon the association
> instead of proceeding with AID 0.

It might be nicer to explcitly state that AIDs distributed by an S1G
AP are done via the AID Response Element as opposed to the
(re)assoc response frame fixed field, so if you have an S1G
assoc response with no AID response it is invalid (In addition to
reading from the non-S1G field etc.).
 
>  	if (elems->aid_resp)
>  		aid = le16_to_cpu(elems->aid_resp->aid);
> -	else
> +	else if (!assoc_data->s1g)
>  		aid = le16_to_cpu(mgmt->u.assoc_resp.aid);
> +	else if (status_code == WLAN_STATUS_SUCCESS)
> +		goto abandon_assoc;
> +	else
> +		aid = 0;

Those last two branches seem a bit weird, the only way to get there
is if you don't have an AID response element with an S1G connection
which is invalid regardless of what the AP status is so I think you
can just have something like:

if (elems->aid_resp)
    aid = le16_to_cpu(elems->aid_resp->aid);
else if (!assoc_data->s1g)
    aid = le16_to_cpu(mgmt->u.assoc_resp.aid);
else
    goto abandon_assoc;

?

lachlan

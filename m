Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30186471407
	for <linux-wireless@vger.kernel.org>; Tue,  1 Sep 2026 08:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788250439; cv=none; b=YhqdXRJH3Gz9KhND4TkO9Qmj6iJWHJu42aFwClMeCRZT6x03KmO8UB2UKwJhGsuoNAqUBy9aOLjuq2vL0UfhX8ynBWqfC37Smpl3Iq/ChzgnpZ9x+ndP2BB1pZQQxrvF8JupDv42P+RFLhE5Ti8OuusIJMVuhTUa2U1lUO1wn+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788250439; c=relaxed/simple;
	bh=bQ2MuMsEaA6cd124dg5a8L6021aAmINtQgBNt70J/B0=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RpNwTeEO1/X2yFNgnt1iF3QRWH5e6nL9f1CyTmLWu0XciPfqqjqYjhqm5xd2qOSqGzjkYpe3MnXfhwiApPeNjB2BpC+Tf+hZ43jb1K+EkqIUH0p3h1vt1cxrOYZYxarmYlx/oRD2cz440WI0lRzoEwR/atzLtHdCYIbC2+zS7Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FKwgoR4f; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FKwgoR4f"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8485b358552so4503105b3a.2
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2026 01:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788250437; x=1788855237; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=R6UY9G7d6bpUV+3zSyJ+KdZpl5Rmgi4WqC7Ji0Vizwc=;
        b=FKwgoR4fHuRaBkbQzFWDVJSVi0ij3OiUiJQb53wLTr/DCltmO+7kb1al1db1BcrNuV
         GN9S8NYuZ/othxOM6dldFqNfpY/vIhqvf8vJxZ40DANU+2CLi4ULGZALxtE0Sud/YkMs
         w90dIMRehS7buawTE6isiX7aZ4/W2RHZXFdxlGzTQAevyURUrwKu/OKqniI5M4ZfPhng
         BJqGdQ2AIpskvpxEOe1RXPd8KqJzKQ+j3yDwtrkwTLdwk0MarsuvshomBPR8jNoqFEKw
         WdINOoqnM01AmA8wOvaIdxeKfruujY1tkX8JmmgDpE3t+LXX4ESpKwTW5r/tWdc+7nGw
         hurg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788250437; x=1788855237;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R6UY9G7d6bpUV+3zSyJ+KdZpl5Rmgi4WqC7Ji0Vizwc=;
        b=ipyFtYCj51DICNFYDAkuhp74y+MekJxoWD2FzMDAbLmRIMOiJPI/7Rq6MdmXNpNeaW
         ygiWN6RUNUy/g+RKWzWSgjGm2//qBCb1/Lw7l8mHuSDdgkGdBwePyZ+j1It8ur1tuS3Z
         wbQxj/gqnWCH4zsAqmkLIWD1Mj8ZF1qN3qsnkXIETSntOzKSU5YEEP0yFTXk23addjq8
         Qodto32pqQvLctVWRJ7IlmAwaTZg6PxDjvacJJ0qdbQeT+C0fE/h44O9VHJ6vNNNob+f
         gms5a8CbkCqCFnYwgu7kMJxLMbrz/zUMQ2pa1oprHxOPHDDfj+EA/sffLi9HYcC9ZNXK
         UAYg==
X-Forwarded-Encrypted: i=1; AHgh+Rr0HuCnUdRTrDwWkCIeEEqVn1MPkTs7AE9B/VEu3mbwdNu9JL1idbWpC7IoHQFs5IoxQpKW5CfA29ym9HGpig==@vger.kernel.org
X-Gm-Message-State: AFuF++kZld2A77j5O0Ps/1iACfh7dO23G9D0wynCqBSKGP6z/98AVlUy
	s1/8HotrJCppdgSQAUUoRmeUQgpMaveQer1WcEa0TowoplqerwiqGe2cce5KGlZNJwg=
X-Gm-Gg: AR+sD12gmNSRhltvxDtRiGg+RhzT27/yW+DnTlW2FHuFP+pIgVVMIczfI4+VyPA81J0
	x4MTm5trG+6FVkhmOgCoeFYiXvh7X0gr3XHPssQyay2NeXojrqVf18lQCPkGdBk9LOjf02aHQrH
	R+QjFbx+p7lRYfAivZY7Bl/JErg6Jbp2vLsvNH9NZyghgizwgmnDFQErAGTn9kZbCO6sYI4bFCf
	u4HYRehwGSH6KBMUDHnBVrY3rDtiBp+Ovss+jbZKc3dz7VqhT9+jPYPiyAF2OuMrEinmgXpQRK2
	idJHn70T3Aug++OCDRQ1gBWvJMBM0fQYPY93tb3VOLzMZCcGYMwrjqCiOm414gaB56mlTpUEAh/
	cI9tDsy6i3VVNLt0anUuC8gvUIECD6gSQIO0zW8z+LB2JAglx83dx/iyFPdGtYhORjrhlDVjC00
	hrkM37LlQ7CDepvoXIlYvW1gRwr/NLuf0Wt4Flwu5Bg9K0hgENVWkeAFE/bHSZkrw/OGOQrCnTK
	KhTJe3ghY9Wd7CvZCCcRJ7COVqXvt1D6rHJAHF1zeCCTG/5Myw=
X-Received: by 2002:a05:6a00:1d8b:b0:837:e9cc:d474 with SMTP id d2e1a72fcca58-85b5968a163mr9681715b3a.2.1788250437469;
        Tue, 01 Sep 2026 01:13:57 -0700 (PDT)
Received: from nxpwireless-Inspiron-14-Plus-7440 (61-228-209-44.dynamic-ip.hinet.net. [61.228.209.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85be66681b7sm734020b3a.23.2026.09.01.01.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 01:13:56 -0700 (PDT)
From: Jeff Chen <chunfan.chen@gmail.com>
X-Google-Original-From: Jeff Chen <jeff.chen_1@nxp.com>
Date: Tue, 1 Sep 2026 16:13:51 +0800
To: Linmao Li <lilinmao@kylinos.cn>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	francesco@dolcini.it, arend.vanspriel@broadcom.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless-next 1/2] wifi: nxpwifi: protect sta_list
 against concurrent add and delete
Message-ID: <apaJP++MI0or+Hyi@nxpwireless-Inspiron-14-Plus-7440>
References: <20260807132554.888706-1-lilinmao@kylinos.cn>
 <20260807132554.888706-2-lilinmao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260807132554.888706-2-lilinmao@kylinos.cn>

On Fri, Aug 07, 2026 at 09:25:53 PM +0800, Linmao Li wrote:
> nxpwifi_del_sta_entry() unlinks an entry from priv->sta_list without
> holding priv->sta_list_spinlock.  The comment above it gives the
> reason: the function is only reached from cfg80211_ops.del_station,
> which runs under the wiphy mutex.

Thanks for the patch. 

Tested on nxpwifi with iw612 chipset.

Tested-by: Jeff Chen <jeff.chen_1@nxp.com>
Reviewed-by: Jeff Chen <jeff.chen_1@nxp.com>

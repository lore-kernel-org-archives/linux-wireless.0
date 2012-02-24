Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40347 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab2BXFY0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 00:24:26 -0500
Received: by vbjk17 with SMTP id k17so1341008vbj.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2012 21:24:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPjQAd9vwbSQuSvWbXvgrMeKt0K7eVx_pxO7K-2xAMnQGVj=Kw@mail.gmail.com>
References: <1330050621-8955-1-git-send-email-ashok@cozybit.com> <CAPjQAd9vwbSQuSvWbXvgrMeKt0K7eVx_pxO7K-2xAMnQGVj=Kw@mail.gmail.com>
From: Javier Cardona <javier@cozybit.com>
Date: Thu, 23 Feb 2012 21:24:05 -0800
Message-ID: <CAPjQAd9p-VFk4C0mDgTwu6k=HKzjvSMOMn2pqytL=UuA3o6tow@mail.gmail.com> (sfid-20120224_062429_077382_5E5A78BB)
Subject: Re: [PATCH] {nl,cfg,mac}80211: Enable control quality monitoring for mesh
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 23, 2012 at 9:21 PM, Javier Cardona <javier@cozybit.com> wrote:
> The logic and the order are wrong.  This needs to be:
>
> +        if (sdata->u.mgd.associated &&
> +        if (sdata->vif.type == NL80211_IFTYPE_STATION &&
>              sdata->u.mgd.associated &&

Sorry, I meant

-        if (sdata->u.mgd.associated &&
+        if (sdata->vif.type == NL80211_IFTYPE_STATION &&
+              sdata->u.mgd.associated &&

-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com

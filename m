Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:17709 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbZBCMyV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 07:54:21 -0500
Received: by wf-out-1314.google.com with SMTP id 27so2228761wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2009 04:54:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <7c8826910902021513o5719927ej12c860d55b49101c@mail.gmail.com>
References: <e27b78a40901230803t8eafb3cx6d70ceaec68daf09@mail.gmail.com>
	 <e27b78a40901260956w4e69d33s7db60defc026c8d7@mail.gmail.com>
	 <45e8e6c40901280954l42bbe788y8723141d673bb7b3@mail.gmail.com>
	 <e27b78a40901300446y294504d5kd7acaa6c5a26edd@mail.gmail.com>
	 <e27b78a40901300601p35d68125kfc3a10a7d7db0900@mail.gmail.com>
	 <7c8826910901301109s6d80a75ale251ec837eabccf0@mail.gmail.com>
	 <e27b78a40902021013v272ec315nece744d3cf1dc75c@mail.gmail.com>
	 <7c8826910902021255g2563400an24f97014abf854f8@mail.gmail.com>
	 <b6c5339f0902021333x2880b7dfj279822622a3d5cc3@mail.gmail.com>
	 <7c8826910902021513o5719927ej12c860d55b49101c@mail.gmail.com>
Date: Tue, 3 Feb 2009 07:54:19 -0500
Message-ID: <b6c5339f0902030454r5ba3ff5eo96702d8cf5c8c994@mail.gmail.com> (sfid-20090203_135425_865393_33FB6686)
Subject: Re: Crashing on ping?
From: Bob Copeland <bcopeland@gmail.com>
To: Mike Cui <cuicui@gmail.com>
Cc: Keir <keirlawson@gmail.com>, Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 2, 2009 at 6:13 PM, Mike Cui <cuicui@gmail.com> wrote:
> No I don't have stack trace. The system completely freezes, to a point
> where even the magic sysreq key doesn't respond. I can try this patch.
> what does it fix, exactly?

The patch is by Christian Lamparter.  It seems we currently accept STAs
that don't advertise any rates we can use, which will cause the rate
controller to eventually select a null rate.  This can happen in AP mode
but I don't know if it has anything to do with the mesh problem.

-- 
Bob Copeland %% www.bobcopeland.com

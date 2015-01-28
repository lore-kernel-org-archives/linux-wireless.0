Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42241 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653AbbA1USi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2015 15:18:38 -0500
Message-ID: <1422431493.1973.5.camel@sipsolutions.net> (sfid-20150128_231011_389316_748EE428)
Subject: Re: [PATCH] pdfdocs: Fix 'make pdfdocs' failure for '80211.tmpl'
From: Johannes Berg <johannes@sipsolutions.net>
To: Sharon Dvir <sharon.dvir1@mail.huji.ac.il>
Cc: "corbet@lwn.net" <corbet@lwn.net>,
	"Coelho, Luciano" <luciano.coelho@intel.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 28 Jan 2015 08:51:33 +0100
In-Reply-To: <1422395060-4281-1-git-send-email-sharon.dvir1@mail.huji.ac.il>
References: <1422395060-4281-1-git-send-email-sharon.dvir1@mail.huji.ac.il>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Interesting CC list - +linux-wireless.

On Tue, 2015-01-27 at 21:44 +0000, Sharon Dvir wrote:
> 'make pdfdocs' failed for 80211.tmpl and reported errors of the form:
> 'document type does not allow element "refentry" here'
> Fixed by moving </section> tags to a location that made sense, fixed the errors and the pdf looks OK in relevant ereas.

I'll apply this and reword the commit log appropriately.

> 
> Signed-off-by: Sharon Dvir <sharon.dvir1@mail.huji.ac.il>
> ---
> diff --git a/Documentation/DocBook/80211.tmpl b/Documentation/DocBook/80211.tmpl
> index 49b8b89..aac9357 100644
> --- a/Documentation/DocBook/80211.tmpl
> +++ b/Documentation/DocBook/80211.tmpl
> @@ -434,7 +434,6 @@
>        <section id="ps-client">
>          <title>support for powersaving clients</title>
>  !Pinclude/net/mac80211.h AP support for powersaving clients
> -      </section>
>  !Finclude/net/mac80211.h ieee80211_get_buffered_bc
>  !Finclude/net/mac80211.h ieee80211_beacon_get
>  !Finclude/net/mac80211.h ieee80211_sta_eosp
> @@ -443,6 +442,7 @@
>  !Finclude/net/mac80211.h ieee80211_sta_ps_transition_ni
>  !Finclude/net/mac80211.h ieee80211_sta_set_buffered
>  !Finclude/net/mac80211.h ieee80211_sta_block_awake
> +      </section>
>        </chapter>
> 
>        <chapter id="multi-iface">
> @@ -487,8 +487,8 @@
>            <title>RX A-MPDU aggregation</title>
>  !Pnet/mac80211/agg-rx.c RX A-MPDU aggregation
>  !Cnet/mac80211/agg-rx.c
> -        </sect1>
>  !Finclude/net/mac80211.h ieee80211_ampdu_mlme_action
> +        </sect1>
>        </chapter>
> 
>        <chapter id="smps">



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:47258 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbaIVLBn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2014 07:01:43 -0400
Received: by mail-ie0-f174.google.com with SMTP id rd18so1832867iec.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Sep 2014 04:01:42 -0700 (PDT)
Date: Mon, 22 Sep 2014 07:00:16 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>, devel@lists.open80211s.org
Cc: linux-wireless@vger.kernel.org,
	Ashok Nagarajan <ashok.dragon@gmail.com>,
	johannes@sipsolutions.net
Subject: Re: [PATCH v3 1/2] iw: Allow user to provide freq during mesh join
Message-ID: <20140922110016.GA302@localhost> (sfid-20140922_130146_755155_AE3A7C68)
References: <1411195244-9130-1-git-send-email-yeohchunyeow@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1411195244-9130-1-git-send-email-yeohchunyeow@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 20, 2014 at 02:40:43PM +0800, Chun-Yeow Yeoh via Devel wrote:
> +	/* freq */
> +	if (argc > 1 && strcmp(argv[0], "freq") == 0) {
> +		argv++;
> +		argc--;

[snip]

> -COMMAND(mesh, join, "<mesh ID> [mcast-rate <rate in Mbps>]"
> +COMMAND(mesh, join, "<mesh ID> [freq in MHz] [HT20|HT40+|HT40-|NOHT]"

Should this be something like:

> +COMMAND(mesh, join, "<mesh ID> [freq <freq in MHz> <HT20|HT40+|HT40-|NOHT>]"

...so we know to specify the 'freq' keyword?

-- 
Bob Copeland %% www.bobcopeland.com

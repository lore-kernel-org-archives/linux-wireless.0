Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.187]:30851 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbXJRNCm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2007 09:02:42 -0400
Received: by rv-out-0910.google.com with SMTP id k20so149443rvb
        for <linux-wireless@vger.kernel.org>; Thu, 18 Oct 2007 06:02:41 -0700 (PDT)
Message-ID: <1ba2fa240710180602m61ae9478k84791690095e76d@mail.gmail.com> (sfid-20071018_140246_586147_CE931299)
Date: Thu, 18 Oct 2007 15:02:41 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [ipw3945-devel] iwl3945 doesn't work
Cc: Stephen.Clark@seclark.us, "Jens Axboe" <jens.axboe@oracle.com>,
	"Dan Williams" <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"=?ISO-8859-1?Q?Ismail_D=F6nmez?=" <ismail@pardus.org.tr>,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1192710788.15285.4.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20071017135452.GJ5043@kernel.dk> <20071017141111.GM5043@kernel.dk>
	 <1192630733.10567.37.camel@localhost.localdomain>
	 <20071017142246.GQ5043@kernel.dk>
	 <1192634183.11584.0.camel@localhost.localdomain>
	 <20071017163519.GC15552@kernel.dk> <47166B5F.1010804@seclark.us>
	 <20071018065746.GB5063@kernel.dk> <47175033.1090709@seclark.us>
	 <1192710788.15285.4.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/18/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2007-10-18 at 08:23 -0400, Stephen Clark wrote:
>
> > >>iwlist eth1 scan would report no scan results, I then switched to loading
> > >>the kernel module with
> > >>the option that tells  iwl3945 to do software scanning and it works
> > >>everytime now.
>
> > In my modprobe.conf file:
> > options iwl3945 disable_hw_scan=1
>
> Hah. Told you it wasn't mac80211's problem. Can somebody remind me again
> exactly why we have hardware scan offload when we parse each received
> packet anyway and the hardware doesn't even batch them so the CPU could
> wake up less?
>
1. Tuning to each channel is done internally by fw so you don't spend
cycles and it's is faster to switch channels so overall scanning take
less time. Sending probe responses is also offloaded.  Returning to
operational channel is more precisely matched to DTIM period as it is
handled by RT code.
2. There are also more advanced modes of scanning such as during voice
traffic etc.
3. Yes beacon batching will be nice, but there is a memory tradeoff.
Tomas

> johannes
>
>

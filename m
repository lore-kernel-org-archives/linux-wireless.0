Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:46389 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785AbXEJQA7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 12:00:59 -0400
Received: by ug-out-1314.google.com with SMTP id 44so626076uga
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2007 09:00:58 -0700 (PDT)
Message-ID: <1ba2fa240705100900j2e4d58cbyc6343b99e01fce63@mail.gmail.com>
Date: Thu, 10 May 2007 19:00:57 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Jouni Malinen" <jkm@devicescape.com>
Subject: Re: Specifing rate control algorithm?
Cc: "Jiri Benc" <jbenc@suse.cz>,
	"James Ketrenos" <jketreno@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070510154859.GA24712@devicescape.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <464253CE.2030504@linux.intel.com>
	 <20070510132756.2ca660a0@midnight.suse.cz>
	 <20070510154859.GA24712@devicescape.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/10/07, Jouni Malinen <jkm@devicescape.com> wrote:
> On Thu, May 10, 2007 at 01:27:56PM +0200, Jiri Benc wrote:
>
> > A driver is not supposed to set rate control. Under no circumstances.
> > If you know about a bug in default rate control algorithm, fix it and
> > send a patch. Otherwise, fix your driver.
>
> I don't think I would fully agree with this. Sure, the default rate
> control algorithm should work with all drivers, but it is quite possible
> that some rate control algorithms do not work with all drivers and some
> combinations are much better than the "default algorithm". In other
> words, I think there is benefit in drivers being able to "suggest" a
> rate control algorithm to be used and there is not much point having to
> force the user space to do this selection for the initial rate control
> algorithm. Sure, this should still be something that can be changed from
> user space, but the defaults selection could as well be the best
> available combination.
>

Just was about to write the same.

> Some hardware designs provide extra functionality that can be used to
> improve rate control algorithm and as such, they may benefit greatly
> from a specific rate control implementation. Because of this, there was
> originally possibility for allowing the rate control algorithms to know
> the driver name and use this to select whether to allow the algorithm to
> be used with the driver. The request here was for a bit different way of
> doing this, but anyway, I see value in this whichever way it would be
> implemented.
>

In addition the interface that passes the  rate scale information
(struct ieee80211_tx_status) from driver to  rate scale algorithm is
not general enough to support  hw specific data.

Tomas

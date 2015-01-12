Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:54568 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbbALJ5T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 04:57:19 -0500
Received: by mail-we0-f178.google.com with SMTP id p10so18013615wes.9
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2015 01:57:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1421055751.1891.10.camel@sipsolutions.net>
References: <1410467723-2550-1-git-send-email-vadim4j@gmail.com>
	<1411075535.2034.5.camel@jlt4.sipsolutions.net>
	<20141014121627.GA5115@angus-think.lan>
	<1413798437.10246.12.camel@jlt4.sipsolutions.net>
	<128188DF-5A9B-47A5-8A89-974CF7CF9064@holtmann.org>
	<1413802344.10246.20.camel@jlt4.sipsolutions.net>
	<CAMw6YJKLWQmT-fqg1QLDHbCxnpxWyJUSX+wvOB_pFyE=8HfSfQ@mail.gmail.com>
	<1420449724.1898.1.camel@sipsolutions.net>
	<CAMw6YJJgPJw7jizR=Qe_2SOK=S0UKrm9AyE7MHUg1-wODEab2g@mail.gmail.com>
	<1421055751.1891.10.camel@sipsolutions.net>
Date: Mon, 12 Jan 2015 11:57:18 +0200
Message-ID: <CAMw6YJJjt4W2JFnUunWgXKL+uUf87dn2LnNSWF6-o2VrXpqiHw@mail.gmail.com> (sfid-20150112_105723_207397_C834185E)
Subject: Re: [PATCH net-next] Allow to set net namespace for wireless device
 via RTM_LINK
From: Vadim Kochan <vadim4j@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you! Seems reasonably for me.

The question is not related to the thread:
     May be this is not very good idea to copy behavior from other
tools but what do you think about
     add the same ability to use named network namespaces as it is
done in iproute2 - from /var/run/netns ?

Thanks,

On Mon, Jan 12, 2015 at 11:42 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2015-01-12 at 11:07 +0200, Vadim Kochan wrote:
>
>> Would you please explain why wireless devs related to the same phy
>> can't live in separated network namespaces ?
>
> Well, they interact very deeply, for example the # of virtual interfaces
> is often severely limited, and they often have to be using a single
> channel, etc. It thus doesn't really make sense to try to separate them.
>
> Also, if you really want to use it reliably, you should use a single
> hostapd or wpa_supplicant process controlling all virtual interfaces,
> which clearly isn't possible in multiple network namespaces.
>
> johannes
>

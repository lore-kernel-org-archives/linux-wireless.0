Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37776 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab1KPXRe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 18:17:34 -0500
Message-ID: <4EC44482.8030301@candelatech.com> (sfid-20111117_001737_311969_D1DABD2E)
Date: Wed, 16 Nov 2011 15:17:22 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	libnl@lists.infradead.org
Subject: Re: crash after updating iw and libnl to latest.
References: <4EC4303E.4090804@candelatech.com>
In-Reply-To: <4EC4303E.4090804@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/16/2011 01:50 PM, Ben Greear wrote:
> I updated everything yesterday, and now iw crashes every time.
> The biggest change was that I updated libnl to the latest....
>
> I'll start digging, but will not be offended if someone
> finds it first!

It seems that the problem is that if you run 'make' in the
iw directory, it doesn't relink if the libraries change.
Somehow it was linked against both new and old libnl-genl
libraries, maybe because I didn't purge the old
libnl libraries after I upgraded it.

I purged all of the old libnl libraries, completely rebuilt
iw, and now it is working much better.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


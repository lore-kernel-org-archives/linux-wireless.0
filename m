Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.188]:62566 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbYIZXab (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 19:30:31 -0400
Received: by fk-out-0910.google.com with SMTP id 18so1117593fkq.5
        for <linux-wireless@vger.kernel.org>; Fri, 26 Sep 2008 16:30:29 -0700 (PDT)
Message-ID: <1ba2fa240809261630y7a8e5f20g75ab47ff98a1e614@mail.gmail.com> (sfid-20080927_013035_350046_CE636B11)
Date: Sat, 27 Sep 2008 02:30:29 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: bad DMAR interaction with iwlagn and SATA
Cc: "Muli Ben-Yehuda" <muli@il.ibm.com>,
	"Jeff Garzik" <jeff@garzik.org>,
	"Andres Freund" <andres@anarazel.de>, linux-kernel@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1222441955.3798.13.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200809251511.20132.andres@anarazel.de>
	 <48DC44D4.8000103@garzik.org> <200809260419.07713.andres@anarazel.de>
	 <48DC4BC0.7090203@garzik.org> <20080926144708.GD9118@il.ibm.com>
	 <1222441955.3798.13.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 26, 2008 at 6:12 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2008-09-26 at 17:47 +0300, Muli Ben-Yehuda wrote:
>
>> The way to debug this is to figure out why device 00:1f.2 is trying to
>> read from DMA address fffbf000 and does not have permission to do
>> so. This could be indicative of a driver bug where it is programming
>> the device to read from some buffer that has not been allocated
>> through the DMA API and thus does not have a valid IOMMU mapping, or a
>> hardware quirk where the device tries to read from memory without host
>> involvement. The former is much more likely.
>
> The same is probably true for the iwlagn case which was
>
>> [ 4184.617392] DMAR:[DMA Read] Request device [03:00.0] fault addr fa946000
>> [ 4184.617393] DMAR:[fault reason 06] PTE Read access is not set
>> [ 4184.644081] iwlagn: Microcode HW error detected.  Restarting.
>
> and indeed matches experience from myself and Marcel that DMA bugs seem
> to lurk.

Meanwhile it all reported bugs in this case points to 64 bit
installations, I'll give it more testing
Thnaks.
Tomas

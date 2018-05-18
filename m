Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:38992 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751858AbeERJDd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 05:03:33 -0400
Message-ID: <1526634208.3805.2.camel@sipsolutions.net> (sfid-20180518_110446_454661_738D7C85)
Subject: Re: ACS ACR122U not working: pn533_usb 1-1:1.0: NFC: Couldn't
 poweron...
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Carlos Manuel Santos <cmmpsantos@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Fri, 18 May 2018 11:03:28 +0200
In-Reply-To: <5AFE9539.4010106@broadcom.com> (sfid-20180518_105700_905753_8ABAEE10)
References: <CACyys_-Z9nnun3TdYFk+0qqoQHcK4CCyCNH-qaGGEf+5GFPkAQ@mail.gmail.com>
         <20180517141217.GA32551@kroah.com> <20180517164004.GA8413@kroah.com>
         <20180517164624.GA28341@kroah.com> <5AFE9539.4010106@broadcom.com>
         (sfid-20180518_105700_905753_8ABAEE10)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-05-18 at 10:56 +0200, Arend van Spriel wrote:
> 
> > +	buffer = kmalloc(sizeof(cmd), GFP_KERNEL);
> > +	if (!buffer)
> > +		return -ENOMEM;
> > +	memcpy(buffer, cmd, sizeof(cmd));

It should also use kmemdup() ;-)

johannes

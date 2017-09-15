Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:52645 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751259AbdIOOdh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 10:33:37 -0400
Received: by mail-io0-f172.google.com with SMTP id i197so8826589ioe.9
        for <linux-wireless@vger.kernel.org>; Fri, 15 Sep 2017 07:33:37 -0700 (PDT)
Subject: Re: rtlwifi/rtl8188ee baseband config explanation request
To: Farhan Khan <khanzf@gmail.com>, linux-wireless@vger.kernel.org
References: <f37044ee-d0fb-1a3a-d98b-3233434f68ea@gmail.com>
 <991a4c76-aff0-499f-11d6-59a4629b9d82@lwfinger.net>
 <4e962e58-3e1a-2d97-b952-26a56c652bae@gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <11e95ad4-68f5-ecae-f4c0-e866be3af397@lwfinger.net> (sfid-20170915_163341_194113_7A556DF5)
Date: Fri, 15 Sep 2017 09:33:35 -0500
MIME-Version: 1.0
In-Reply-To: <4e962e58-3e1a-2d97-b952-26a56c652bae@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/15/2017 01:26 AM, Farhan Khan wrote:
> Thank you for your prompt response.
> 
> I am trying to write a FreeBSD port of this driver. The structures of
> the two drivers are significantly different, so it is not a trivial
> exercise.
> 
> The FreeBSD driver also has a similar block of code that writes over an
> array of data using an array of registers, and this should be easy to
> re-create. But I do not see the equivalent of phy_config_bb_with_pghdr()
> anywhere. I do not know if I need to maintain the order for any reason.
> 
> I attempted to reach out to Realtek through multiple mediums but did not
> receive any replies. Ultimately, I may end up re-playing the same bits
> without understanding what is happening.

You should have stated your purpose at the start.

Those sections are loading data for the firmware to use. As you probably are not 
writing your own firmware, and not doing your own calibration, then you should 
just copy all the code that touches the data in the file table.c. The firmware 
does not care whether the host is Linux or FreeBSD. It still has to do that same 
operations on the radio, and this is the data it needs.

As I said in my initial response, I think the PHY register data needs to be 
written before the AGC data as the latter is being written into a buffer that is 
not directly accessible from the host, which means some previous step has set up 
that transfer. As we do not know what that was, you likely need to do everything 
in the same order.

Larry

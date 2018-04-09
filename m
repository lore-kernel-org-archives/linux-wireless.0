Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f182.google.com ([74.125.82.182]:36135 "EHLO
        mail-ot0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756347AbeDIAbj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 8 Apr 2018 20:31:39 -0400
Received: by mail-ot0-f182.google.com with SMTP id n40-v6so6809150otd.3
        for <linux-wireless@vger.kernel.org>; Sun, 08 Apr 2018 17:31:39 -0700 (PDT)
Subject: Re: iwlwifi-7265-ucode-25.30.14.0.tgz. in Centos 7
To: Dusan Bruncko <dusan.bruncko@cern.ch>,
        linux-wireless@vger.kernel.org, centos-devel@centos.org
References: <fe3605be-8ce1-ee6f-7ea2-7f736f5493fb@cern.ch>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <238bda30-c983-f4aa-fdaf-a4f06cb83c1d@lwfinger.net> (sfid-20180409_023212_478269_A7149A88)
Date: Sun, 8 Apr 2018 19:31:37 -0500
MIME-Version: 1.0
In-Reply-To: <fe3605be-8ce1-ee6f-7ea2-7f736f5493fb@cern.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/08/2018 01:58 AM, Dusan Bruncko wrote:
> Hello,
> 
> Allow me to ask you the following question:
> 
> I have laptop with: "02:00.0 Network controller: Intel Corporation Wireless 7265 
> (rev 59)".
> For this device I found firmware iwlwifi-7265-ucode-25.30.14.0.tgz.
> 
> My problem is following: This firmware was created for kernel 4.2+, but I am using
> Centos 7 with kernels a la 3.10. Therefore I see during booting and after switch 
> off some
> problematic messages a la:
> capa flags index 3 larger than supported by driver  or
> failed to remove key (2, ff:ff:ff:ff:ff:ff) from hardware ...
> 
> Wi-fi works properly, not to look on the previous messages.
> 
> My question to you: do you have in schedule to include proper firmware also for
> centos 7/redhat 7?

If your kernel were newer, I would recommend running the backports drivers, but 
I think 3.10 is too old. That said, this code change would not fix the "failed 
to remove key" message as I get that on my 7260 device with kernel 4.16.0. I 
think you may safely ignore this one if for no other reason than it only happens 
when the device is being shut down.

If the "capa flags index 3" message is not causing any problems, I would ignore 
it as well.

Larry

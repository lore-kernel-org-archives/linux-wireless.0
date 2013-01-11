Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58411 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab3AKAxo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2013 19:53:44 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so940605lbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jan 2013 16:53:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1363680.r8KF83dygC@lx-vladimir>
References: <6929081.7c7blFVDp4@lx-vladimir> <1363680.r8KF83dygC@lx-vladimir>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 11 Jan 2013 11:45:43 +1100
Message-ID: <CAGRGNgVUq=8H-r=tA3W5ojyfWPfPt8YHB2zDVpK5EWeF-=5unw@mail.gmail.com> (sfid-20130111_015349_148005_F18A4429)
Subject: Re: Q: how to update platform power state for the network driver
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Vladimir,

On Thu, Jan 10, 2013 at 11:06 PM, Vladimir Kondratiev
<qca_vkondrat@qca.qualcomm.com> wrote:
> On Wednesday, January 09, 2013 07:20:06 PM Vladimir Kondratiev wrote:
>> What is the best way to obtain this info in the network driver?
>>
>
> Found:
>
> #include <linux/power_supply.h>
> int power_supply_is_system_supplied(void);
>
> returns:
> positive if system is AC supplied,
> 0 if battery supplied
> negative on error

One minor point: you might want to add the ability to override this,
even if it's only through debugfs so that people testing the code, or
with unusual requirements can set this how they want / need it.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/

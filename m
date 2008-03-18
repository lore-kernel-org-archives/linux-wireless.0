Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:14052 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936388AbYCSVKK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 17:10:10 -0400
Received: by wa-out-1112.google.com with SMTP id v27so639856wah.23
        for <linux-wireless@vger.kernel.org>; Wed, 19 Mar 2008 14:10:07 -0700 (PDT)
Message-ID: <1ba2fa240803181607n3556955ar39eebdeebacffb7b@mail.gmail.com> (sfid-20080319_211051_183597_735DD226)
Date: Wed, 19 Mar 2008 01:07:46 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Subject: Re: [ipw3945-devel] iwl3945 rfkill regression
Cc: drago01 <drago01@gmail.com>, "Dan Williams" <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"Cahill, Ben M" <ben.m.cahill@intel.com>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <D936D925018D154694D8A362EEB0892003F2D574@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <f6ca9fed0801221204j71ad2137l19555363e46a7e45@mail.gmail.com>
	 <f6ca9fed0801221224u7ddf1569qa29860466ac27d86@mail.gmail.com>
	 <f6ca9fed0801261100j7939056dke661a422ec507fce@mail.gmail.com>
	 <1ba2fa240801261411x7bb437c9s31aea593537afeba@mail.gmail.com>
	 <47B29F63.6050605@gmail.com>
	 <D936D925018D154694D8A362EEB0892003A7F599@orsmsx416.amr.corp.intel.com>
	 <f6ca9fed0803181232n4ac188ev5d10e7c68aad57aa@mail.gmail.com>
	 <D936D925018D154694D8A362EEB0892003F2D487@orsmsx416.amr.corp.intel.com>
	 <f6ca9fed0803181446v139b688ek958ce29cf7d98457@mail.gmail.com>
	 <D936D925018D154694D8A362EEB0892003F2D574@orsmsx416.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 19, 2008 at 12:06 AM, Chatre, Reinette
<reinette.chatre@intel.com> wrote:
>
> On Tuesday, March 18, 2008 2:47 PM, drago01  wrote:
>
>  >>  Please note that the driver loads/unloads the firmware during
>  >>  interface up/down. That means that the host will not receive rfkill
>  >>  events while the interface is down as there is no firmware to deal
>  >> with these events.
>  >>
>  >>  Reinette
>  >>
>  >
>  > OK that makes sense.
>  > So a solution would be to not unload the firmware on down when the hw
>  > rfkill is on. Is this a acceptable one or are they other (better
>  > solutions). I can't think of any. And userspace cannot do anything
>  > because bringing the device up and down again to look for the rfkill
>  > status would be racy.
>
>  Having the firmware unloaded when the interface is down is a requirement
>  for powersaving. We do not want the device to consume power when it is
>  not used. The rfkill status should always be reported accurately when
>  the interface is up. If it is not then it is a bug.

We will catch the HW rfkill event after loading the uCode so there is
no problem with this.
Not sure where should be the SW rfkill state stored.

>  Reinette
>

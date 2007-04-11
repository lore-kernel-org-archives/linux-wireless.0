Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.232]:23035 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161358AbXDKXFE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2007 19:05:04 -0400
Received: by wr-out-0506.google.com with SMTP id 71so283179wri
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2007 16:05:03 -0700 (PDT)
Message-ID: <1ba2fa240704111605l305230d3vf09c085473364eb3@mail.gmail.com>
Date: Thu, 12 Apr 2007 02:05:02 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Simon Barber" <simon@devicescape.com>
Subject: Re: [patch 2/5] Add basic support for IEEE 802.11n discovery and association
Cc: "Michael Wu" <flamingice@sourmilk.net>,
	mabbas <mabbas@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Jouni Malinen" <jkm@devicescape.com>
In-Reply-To: <C86180A8C204554D8A3323D8F6B0A29F01DEB33D@dhost002-46.dex002.intermedia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <1174909105.1364.53.camel@dell-4965.jf.intel.com>
	 <20070411194059.GA2436@tuxdriver.com> <461D3F48.70004@linux.intel.com>
	 <200704111630.06160.flamingice@sourmilk.net>
	 <1ba2fa240704111503l6dcef504na73c997ae75ebccd@mail.gmail.com>
	 <C86180A8C204554D8A3323D8F6B0A29F01DEB33D@dhost002-46.dex002.intermedia.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So you monitor your traffic load in driver, then notify user space
application which opens or tears down for you the BA stream?
What would be the notification mechanism ?


On 4/12/07, Simon Barber <simon@devicescape.com> wrote:
> Setup and tear down of BA should be done by userspace - actual
> processing of the BA frames themselves should be done in mac80211. This
> allows maximum flexibility from userspace to control the policy of when
> to setup and teardown BA streams.
>
> Simon
>
> -----Original Message-----
> From: Tomas Winkler [mailto:tomasw@gmail.com]
> Sent: Wednesday, April 11, 2007 3:04 PM
> To: Michael Wu
> Cc: mabbas; John W. Linville; linux-wireless@vger.kernel.org; Jouni
> Malinen; Simon Barber
> Subject: Re: [patch 2/5] Add basic support for IEEE 802.11n discovery
> and association
>
> On 4/11/07, Michael Wu <flamingice@sourmilk.net> wrote:
> > On Wednesday 11 April 2007 16:04, mabbas wrote:
> > > I am not familiar with userspace mlme what needed to be done?
> > mac80211 has a userspace mlme mode which defers all things dealing
> > with management frames to userspace (wpa_supplicant). It basically
> > disables all the code in ieee80211_sta.c and routes management frames
> > to a special interface where wpa_supplicant (or hostap) handles
> > things. This is preferred and the ieee80211_sta.c code is there for
> backwards compatibility.
> >
> > No major features should be added to the in-kernel MLME
> > (ieee80211_sta.c) but even more importantly, your patch series does
> > not provide the appropriate hooks for a userspace MLME to support a
> driver using this 802.11n API.
> >
> > -Michael Wu
> >
> >
> Meanwhile I don't see feasible user space implementation for this as
> data packet classification is done in kernel. BACK streams are
> dynamically  opened and teared down per TID according current traffic
> shape.
> This is new feature and the user space handling is not well understand
> yet. I suggest that we proceed with patches and let the evolution making
> its steps.
>
> If someone has concrete suggestion on implementing it as user space MLME
> I will be glad to hear.
> Thanks
>
>
> Tomas
>

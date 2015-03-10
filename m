Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:36208 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243AbbCJQXK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 12:23:10 -0400
Date: Tue, 10 Mar 2015 09:18:02 -0700
From: Tony Lindgren <tony@atomide.com>
To: Eliad Peller <eliad@wizery.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Sekhar Nori <nsekhar@ti.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH v5 3/3] ARM: dts: igep00x0: add wl18xx bindings
Message-ID: <20150310161801.GR5264@atomide.com> (sfid-20150310_172438_356236_ACBBF1E6)
References: <1425915402-10012-1-git-send-email-eliad@wizery.com>
 <2223973.a64rBcZvaA@wuerfel>
 <CAB3XZEftjwUGS_Kj2dCxYY1m82C+a1_=akbnG3_hLETCr+Dddg@mail.gmail.com>
 <5683860.JYkc24rKim@wuerfel>
 <CAB3XZEfEQnb7qsxuAAr6pUehm1nw6Eu4ZsV1+E477yF5K1hczA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAB3XZEfEQnb7qsxuAAr6pUehm1nw6Eu4ZsV1+E477yF5K1hczA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Eliad Peller <eliad@wizery.com> [150310 09:11]:
> On Tue, Mar 10, 2015 at 5:52 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Tuesday 10 March 2015 16:31:33 Eliad Peller wrote:
> >> On Tue, Mar 10, 2015 at 4:11 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> > On Tuesday 10 March 2015 13:00:19 Eliad Peller wrote:
> >> >> On Tue, Mar 10, 2015 at 12:49 AM, Tony Lindgren <tony@atomide.com> wrote:
> >> >> >> > I was expecting you to remove all calls to legacy_init_wl12xx from this file,
> >> >> >> > including the ones for wl12xx aside from the wl18xx ones you removed, but
> >> >> >> > if that's enough to clean out the platform_data handling from the wlcore
> >> >> >> > driver, it's good enough as a start.
> >> >> >> not sure i'm following - can you elaborate?
> >> >> >>
> >> >> >> i'll summarize the way i see it. please correct me if i'm wrong.
> >> >> >>
> >> >> >> both wl18xx and wl12xx use the platform data to get the irq number.
> >> >> >> wl12xx (only) also needs some additional clock definitions to be
> >> >> >> passed. there's currently some issue with specifying some the of clock
> >> >> >> sources, so i preferred starting only with (the simpler) wl18xx
> >> >> >> bindings.
> >> >> >>
> >> >> >> for platforms with wl18xx, we can remove the pdata-quirk, as all the
> >> >> >> data (i.e. irq) can be passed by the new DT bindings.
> >> >> >> however, for platforms with wl12xx, we still need to pass the clock
> >> >> >> definitions (along with the irq), so we have to keep
> >> >> >> legacy_init_wl12xx for the time being (and that's also why we have to
> >> >> >> currently keep the platform_data handling in the wlcore driver)
> >> >> >>
> >> >> >> do you have something else in mind?
> >> >> >
> >> >> > I think what Arnd is saying is we've now removed all the wl12xx using
> >> >> > legacy platforms, so all of them can boot with just data from dts.
> >> >
> >> > Right, that was my idea.
> >> >
> >> >> I don't think that's the case (unless i'm missing something).
> >> >> e.g. there's still pdata-quirk for "compulab,omap3-sbc-t3730" which
> >> >> initializes wl12xx device.
> >> >
> >> > This one is just like the igep0030, as Tony was saying: the board
> >> > boots from device tree already, so now that we have a binding for
> >> > it, we can remove the wl12xx_set_platform_data() for it.
> >> >
> >> i think the wl12xx_set_platform_data() name created some confusion -
> >> it is used to pass platform data for both wl12xx and wl18xx devices.
> >> (this confusion is all around the wlcore driver as well, due to the
> >> code evolution)
> >>
> >> the binding i added is for wl18xx only (there is no wl12xx binding yet).
> >> the remaining boards, AFAICT, have wl12xx (rather than wl18xx) cards.
> >> so i don't see how we can remove these wl12xx_set_platform_data()
> >> calls before we have wl12xx bindings in-place as well.
> >
> > What is missing for that binding then? I keep getting confused here,
> > but I thought that they share the implementation that looks at the
> > platform data.
> >
> they both get the same wl12xx_platform_data struct, but only wl12xx
> cares about the clocks-related fields.
> the bindings i added parses only the irq.
> 
> (Luca tried previously to upstream wl12xx DT support along with the
> required clock DT changes, but got some rejections, mainly wrt. clock
> stuff.
> e.g. http://thread.gmane.org/gmane.linux.kernel/1520752
> that's why i preferred starting with "easier" wl18xx bindings only)

I believe we did not have clock bindings back then, now it's simple
to get the clock. If it's some internal clock to the wl12xx, then
that's a different story, it should be just hidden behind a compatible
flag then.

Regards,

Tony

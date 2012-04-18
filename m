Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:5407 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531Ab2DRLTc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 07:19:32 -0400
Date: Wed, 18 Apr 2012 14:20:19 +0300
From: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [RFCv1] mac80211: Adds Software / Virtual AMP 80211
Message-ID: <20120418112017.GC19228@aemeltch-MOBL1> (sfid-20120418_131938_027534_31BCFB59)
References: <1334059909-20513-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
 <1334059909-20513-2-git-send-email-Andrei.Emeltchenko.news@gmail.com>
 <4F846257.1060807@sipsolutions.net>
 <1334092668.16897.54.camel@aeonflux>
 <4F84A422.3030900@sipsolutions.net>
 <1334093378.16897.62.camel@aeonflux>
 <20120411070514.GB17779@aemeltch-MOBL1>
 <1334714841.3725.37.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1334714841.3725.37.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Tue, Apr 17, 2012 at 07:07:21PM -0700, Johannes Berg wrote:
> > > > >> I don't get this patch at all. Why am I reviewing some very very basic
> > > > >> skeleton code when we should be discussing userspace APIs (we have
> > > > >> already discussed them with a few people years ago), how the AMP is
> > > > >> going to be managed, how the security handshake is going to work, etc.
> > 
> > Do we have some outcome from that discussion?
> 
> This API-defining patch is probably the best we have:
> http://johannes.sipsolutions.net/patches/kernel/all/2010-10-13-15%
> 3a24/035-bt3-amp.patch

Thanks for the link. After looking to the patches I think that there are
some similarities with respect to interface type. As I understood the
basic idea is the same: create virtual interface. But in your case the
implementation is really difficult.

Why do we need netlink commands like NL80211_CMD_HCI_AMP_ADD and
NL80211_CMD_HCI_AMP_DELETE if what we need is to create/delete virtual
interface which can be done with standard tools with a several lines
patch to iw:

<------8<---------------------------------------------------------------------
|  diff --git a/interface.c b/interface.c
|  index 6c90f9d..49227ce 100644
|  --- a/interface.c
|  +++ b/interface.c
|  @@ -136,6 +136,9 @@ static int get_if_type(int *argc, char ***argv, enum
|  nl80211_iftype *type,
|          } else if (strcmp(tpstr, "__p2pgo") == 0) {
|                  *type = NL80211_IFTYPE_P2P_GO;
|                  return 0;
|  +       } else if (strcmp(tpstr, "vamp") == 0) {
|  +               *type = NL80211_IFTYPE_VIRTUAL_AMP;
|  +               return 0;
|          }
|
|          fprintf(stderr, "invalid interface type %s\n", tpstr);
|  diff --git a/nl80211.h b/nl80211.h
|  index e474f6e..ad4a252 100644
|  --- a/nl80211.h
|  +++ b/nl80211.h
|  @@ -1546,6 +1546,7 @@ enum nl80211_iftype {
|          NL80211_IFTYPE_MESH_POINT,
|          NL80211_IFTYPE_P2P_CLIENT,
|          NL80211_IFTYPE_P2P_GO,
|  +       NL80211_IFTYPE_VIRTUAL_AMP,
|
|          /* keep last */
|          NUM_NL80211_IFTYPES,
|  diff --git a/util.c b/util.c
|  index 103ded9..bf2fefe 100644
|  --- a/util.c
|  +++ b/util.c
|  @@ -132,6 +132,7 @@ static const char *ifmodes[NL80211_IFTYPE_MAX + 1] = {
|          "mesh point",
|          "P2P-client",
|          "P2P-GO",
|  +       "Virtual AMP",
|   };
|
|   static char modebuf[100];
|
<------8<---------------------------------------------------------------------

Anyway I think that this is not an issue since those commands can be
easily added.

> > > The whole AMP control goes via A2MP and L2CAP and both are fully
> > > implemented inside the kernel. In theory we do not even need to expose
> > > HCI AMP interfaces to userspace.
> > 
> > Johannes, you can think of SoftAMP as analog of SoftMAC (vs FullMAC).
> > SoftMAC is also possible to implement in user space but only
> > authentication is done this way.
> 
> Yeah, and we also implement roaming and crypto stuff in userspace, for
> softmac. Heck, we implement crypto in userspace even for fullmac, so
> really ...

Does crypto stuff mean getting symmetric key?

I see that all commands by default are sent via netlink to wpa_supplicant.
I think that we can send those command which cannot be handled by us
directly but I believe most command might be handled directly.

> > Consider use case when user sends data over Bluetooth High Speed. Data
> > go from obex user space to kernel L2CAP. Then you just need to add
> > MAC header and send to wireless device. But you are proposing to copy data
> > to user space for processing; then user space needs to copy data again to 
> > kernel and then to wireless device.
> 
> I never said data should be copied. If you thought I did, you
> misunderstood me.

I see now that data are sent directly through ieee80211_tx_skb and
received through ieee80211_deliver_skb. BTW: Have you tested those patches?

Best regards 
Andrei Emeltchenko 


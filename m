Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.181]:42023 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbYCQMkm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 08:40:42 -0400
Received: by el-out-1112.google.com with SMTP id v27so2889607ele.17
        for <linux-wireless@vger.kernel.org>; Mon, 17 Mar 2008 05:40:41 -0700 (PDT)
Message-ID: <1ba2fa240803170540n2e6fb398p84abfb34e4124042@mail.gmail.com> (sfid-20080317_124047_596911_828E6D76)
Date: Mon, 17 Mar 2008 14:40:40 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [ipw3945-devel] [PATCH 1/5] mac80211: allows driver to request a Phase 2 key
Cc: "Reinette Chatre" <reinette.chatre@intel.com>,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1205751455.1614.25.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1205366762-12828-1-git-send-email-reinette.chatre@intel.com>
	 <1205366762-12828-2-git-send-email-reinette.chatre@intel.com>
	 <1205591906.15910.44.camel@johannes.berg>
	 <1ba2fa240803161721q5d01bve2292f99d3fe9eb8@mail.gmail.com>
	 <1205747912.1614.19.camel@johannes.berg>
	 <1ba2fa240803170320i4805e055ofebbbd9928a59354@mail.gmail.com>
	 <1205751455.1614.25.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 17, 2008 at 12:57 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>  > >  Actually, you're making it look like a much larger problem than it is.
>  > >  If you assume anything WEP is a "static key" and everything else is a
>  > >  "dynamic key" (using your terminology), the only problem will be with
>  > >  dynamic WEP, and even then it's not really a problem because as far as I
>  > >  understand even dynamic WEP doesn't distinguish between group and
>  > >  pairwise keys.
>  >
>  > This is incorrect.  WPA enable using WEP as dynamic key and this
>  > setting is very common.
>  > WEP key is enabled for legacy stations this force also broadcast to be
>  > WEP.  This setup is still quite common.

>  I have no idea about WPA's non-IEEE modes. I don't seem to be able to
>  find such a thing in the IEEE spec so you'll have to actually elaborate
>  on this.

Actually I've misled you a bit. This is defined by IEEE 802.11i in
section TSN Transition Security Network. Where legacy WEP-only STA and
RSN-enabled station can coexists.  In this case Legacy stations use
static WEP key and RSN enabled station uses more advanced security
setting. RSN enabled station will be configured with WEP as a group
cipher  (spec name)

Here is a quote from the spec.. there is much more about it it's a bit
spread in the spec.

3.123 Transition Security Network (TSN): A Security Network which
allows the creation of Pre-Robust
Security Network Associations as well as Robust Security Network
Associations. A TSN can be identified
by the indication in the RSN IE of Beacons that the group cipher suite
in use is WEP.

>

>  > >  Note that there's another case in AP mode where bc/mc keys are TX-only,
>  > >  those are added with a zeroed MAC address.

>  > I would prefer also in this case a clear flag rather then playing with
>  > ambiguity of destination address.

On second thought is that AP has only TX group key while STA has only
RX group key so I
m not seeing here any need for flag.

>
>  Yes, that would indeed help. Except that WEXT can't actually give you
>  the distinction so discussing these points right now is pretty moot when
>  we can't even do it properly as far as I can tell. Might be possible to
>  infer the information with the key management enabled flag thing...

You have encode ioctl which is called only for static/legacy WEP or
you use CIPHER_NONE  for when using encodeext
For WEP in Pairwise and Group Key you use WEP40/104

/* IW_AUTH_PAIRWISE_CIPHER and IW_AUTH_GROUP_CIPHER values (bit field) */
#define IW_AUTH_CIPHER_NONE	0x00000001
#define IW_AUTH_CIPHER_WEP40	0x00000002
#define IW_AUTH_CIPHER_TKIP	0x00000004
#define IW_AUTH_CIPHER_CCMP	0x00000008
#define IW_AUTH_CIPHER_WEP104	0x00000010

It's not well defined in wext but we can at least define the interface
from mac80211 point of view.


Thanks
Tomas

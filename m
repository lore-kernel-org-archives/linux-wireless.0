Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:40584 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932473Ab2CZOci (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 10:32:38 -0400
Date: Mon, 26 Mar 2012 09:32:32 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: =?utf-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"sgruszka@redhat.com" <sgruszka@redhat.com>,
	"jrnieder@gmail.com" <jrnieder@gmail.com>
Subject: Re: brcmsmac still woes, possible regression?
Message-ID: <20120326143232.GA17126@thinkpad-t410> (sfid-20120326_163243_779824_EAE65089)
References: <CAKprTDELdRWtJWpmn9RMuMUYXxuaR6Cf41+jot4_fZixHQtcMw@mail.gmail.com>
 <4F6D939F.3030206@broadcom.com>
 <CAKprTDHSyh2Sv2wyY0hg4cjzWobV-zA4stY19-vB_hOBVAq5KQ@mail.gmail.com>
 <CAKprTDHpLtPu2+navGzJU9K8XX-h=Purw_q_Qs2mYn4QFEex+w@mail.gmail.com>
 <4F7035AD.1080503@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4F7035AD.1080503@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 26, 2012 at 11:23:57AM +0200, Arend van Spriel wrote:
> On 03/24/2012 12:21 PM, Camaleón wrote:
> >2012/3/24 Camaleón<noelamac@gmail.com>:
> >
> >>I will keep and eye on this, bu all seems good and working fine now.
> >
> >Okay, I got another trace :-(
> >
> >NetworkManager asked for the password (which was already set and
> >printed at the input box, I didn't have to type it again) and
> >reconnected fine but it logged the trace at /var/log/messages.
> >
> >See attached files.
> >
> 
> The WARNING message is preceded by a cfg80211 message regarding
> world regulatory domain. I suspect there is a relatio, but not sure
> what it is. Regarding channels 12 and 13 I will come up with a fix
> today and send you the patch to try.

The trace is related to handling a disconnection, which will also
trigger a reprocessing of the regulatory rules. The warning and the
regulatory message share a common cause, but I don't think there's a
direct relationship between them.

This also seems to indicate that by the time either of these messages
appears the connection with the AP is already in the process of being
dropped. I don't think the regulatory messages give any cluse as to why
the connection was dropped. I suppose the warning might but I don't
know.

Seth


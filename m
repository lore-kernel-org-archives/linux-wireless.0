Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.186]:13084 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451AbYEMNDX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 09:03:23 -0400
Received: by fk-out-0910.google.com with SMTP id 18so2260058fkq.5
        for <linux-wireless@vger.kernel.org>; Tue, 13 May 2008 06:03:19 -0700 (PDT)
Message-ID: <8704f27d0805130603q798b1a2bw76319df1251e9e01@mail.gmail.com> (sfid-20080513_150328_322665_528C58D1)
Date: Tue, 13 May 2008 16:03:19 +0300
From: "Emmanuel Grumbach" <egrumbach@gmail.com>
To: "Jouni Malinen" <j@w1.fi>
Subject: Re: 11n + wpa_supplicant
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Linux Wireless" <linux-wireless@vger.kernel.org>,
	"Tomas Winkler" <tomasw@gmail.com>,
	"Dan Williams" <dcbw@redhat.com>
In-Reply-To: <20080513125024.GD6309@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <8704f27d0805130118p6f597743sebed5a2cdb6d59cb@mail.gmail.com>
	 <20080513122718.GA6309@jm.kir.nu>
	 <1210682080.3646.73.camel@johannes.berg>
	 <20080513125024.GD6309@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 13, 2008 at 3:50 PM, Jouni Malinen <j@w1.fi> wrote:
> On Tue, May 13, 2008 at 02:34:40PM +0200, Johannes Berg wrote:
>
>  > > In most cases, the pairwise cipher is selected during association, not
>  > > during 4-way handshake. Consequently, the driver/firmware should refuse
>  > > to send an (Re)Association Request that requests TKIP as the pairwise
>  > > cipher when using .11n.
>  >
>  > So to do this we should look at the associate IE(s) we get from
>  > userspace for association, right?
>
>  Well, at least in theory, yes, we could refuse to send the frame if
>  WPA/RSN IE requests TKIP as the pairwise cipher and we would be using
>  .11n (or alternatively, just drop to legacy mode). However, I think it
>  would be better to leave this task to whatever component picks the BSS,
>  i.e., in this particular case to userspace if the request is indeed to
>  associate with a specific WPA/RSN IE and a selected BSSID.
>
>  If ap_scan=2 were to be used (I don't think this is supported in
>  mac80211 or at least it wasn't originally), the task would be in kernel
>  code, but in that case, the pairwise cipher would be configured as a
>  separate parameter and there would be no need to parse IEs to figure it
>  out.
>
>
>  > I'd think we can also just include the HT IE in the scan result. Or, why
>  > not just include all of them, parsers must be able to tell them apart
>  > anyway and NM could display an HT icon for example then.
>
>  I would recommend to include all the IEs. This should have been the
>  design from the beginning, but well, it wasn't at least enforced very
>  strongly. I've changed wpa_supplicant to use full set of IEs internally
>  and WPA/RSN IE(s) are already converted to this format if only those IEs
>  are available and drivers should just report all the IEs from
>  Beacon/ProbeResp frames with IWEVGENIE when using WEXT.
>
>
>
>  --
>  Jouni Malinen                                            PGP id EFC895FA
>

So, If I understand you well, we should pass the HT IE using IWEVGENIE
during scan, and wpa_supplicant will detect the conflict between
encryption method and HT, and will request association in legacy mode
(or won't allow the encryption method according to what has
precedence: security or 11n).

Am I correct ?

-- 
Emmanuel Grumbach
egrumbach@gmail.com

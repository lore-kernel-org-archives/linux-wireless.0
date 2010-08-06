Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mundo.umh.es ([193.147.147.4]:43398 "EHLO mundo.umh.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756181Ab0HFKs4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 06:48:56 -0400
From: =?iso-8859-1?Q?J=F3natan_Mu=F1oz?= <jmunoz@umh.es>
To: "'John W. Linville'" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
References: <002c01cb3495$0ff49610$2fddc230$@es> <20100805134531.GA2779@tuxdriver.com>
In-Reply-To: <20100805134531.GA2779@tuxdriver.com>
Subject: RE: [ath9k]: Beaconing process in ad-hoc mode
Date: Fri, 6 Aug 2010 12:48:44 +0200
Message-ID: <000001cb3554$f6d21840$e47648c0$@es>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear John,

Thanks for your help. I am looking in net/mac80211/ibss.c.
I see the ieee80211_rx_mgmt_beacon function but I don't find anything about
beacon tx, or about tsf update. I am still lost.

static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
				     struct ieee80211_mgmt *mgmt,
				     size_t len,
				     struct ieee80211_rx_status *rx_status)
{
	size_t baselen;
	struct ieee802_11_elems elems;

	/* Process beacon from the current BSS */
	baselen = (u8 *) mgmt->u.beacon.variable - (u8 *) mgmt;
	if (baselen > len)
		return;

	ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen,
&elems);

	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems, true);
}


Any tip more, please?

Thank you in advance

John



------------------------------------------
Jónatan Muñoz
Email: jmunoz@umh.es
Ubiquitous Wireless Communications Research Laboratory 
Uwicore, http://www.uwicore.umh.es 
Signal Theory and Communications Division 
University Miguel Hernández of Elche 

Avenida de la Universidad s/n 
Edificio Quorum V P2 012
03202, Elche (Alicante) 
Spain 
Tel: +34 96522 2031 /+34 669256708
Fax: +34 96665 8903 
------------------------------------------

> -----Mensaje original-----
> De: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> owner@vger.kernel.org] En nombre de John W. Linville
> Enviado el: jueves, 05 de agosto de 2010 15:46
> Para: Jónatan Muñoz
> CC: linux-wireless@vger.kernel.org
> Asunto: Re: [ath9k]: Beaconing process in ad-hoc mode
> 
> On Thu, Aug 05, 2010 at 01:55:05PM +0200, Jónatan Muñoz wrote:
> > Dear All,
> >
> > I am working in a project where I need to modified the currently
> beaconing
> > system for adhoc mode in ath9k, what I want to achieve is that each
> station
> > in an adhoc network send periodically a beacon. As I know, when a
> station in
> > the network receives a beacon before sending its own beacon, cancels
> the
> > transmission, updates its hw tsf based on the received beacon and
> waits for
> > a chance to send the beacon during next TBTT.
> >
> > For my goal, I think that I should comment the part where the
> transmission
> > of the beacon is cancelled. In this way, each station will send a
> beacon
> > each 100TU (~100 ms). I know that this mean a increased traffic load
> on the
> > network, but it is so much important for the project to obtain a
> beacon for
> > each station each 100ms.
> >
> > Right now, I am looking at the source code of ath9k, I am trying to
> modify
> > the file beacon.c, but I don’t find the way to get my purpose. Could
> anyone
> > help me to find the right place at the code that I have to modify? I
> am a
> > bit lost and any help would be greatly appreciated.
> >
> > Thanks in advance.
> >
> > PD: Please excuse my poor English
> >
> > John
> 
> I think you should be looking in net/mac80211/ibss.c.
> 
> Hth!
> 
> John
> --
> John W. Linville		Someday the world will need a hero, and you
> linville@tuxdriver.com			might be all we have.  Be
ready.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


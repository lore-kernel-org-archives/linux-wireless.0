Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:37373 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525AbYGGT0s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2008 15:26:48 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2235338wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jul 2008 12:26:47 -0700 (PDT)
Subject: Re: [PATCH 1/1 V2] mac80211: Fix ieee80211_rx_reorder_ampdu:
	ignore QoS null packets
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Tomas Winkler <tomas.winkler@intel.com>, linville@tuxdriver.com,
	johannes@sipsolutions.net, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <200807071902.51683.mb@bu3sch.de>
References: <1215434881-5410-1-git-send-email-tomas.winkler@intel.com>
	 <1215447824.14247.2.camel@brick>  <200807071902.51683.mb@bu3sch.de>
Content-Type: text/plain; charset=utf-8
Date: Mon, 07 Jul 2008 12:26:32 -0700
Message-Id: <1215458792.14247.7.camel@brick> (sfid-20080707_212653_129201_41BD2067)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-07-07 at 19:02 +0200, Michael Buesch wrote:
> On Monday 07 July 2008 18:23:44 Harvey Harrison wrote:
> > On Mon, 2008-07-07 at 15:48 +0300, Tomas Winkler wrote:
> > > From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > >=20
> > > This patch fixes the check at the entrance to ieee80211_rx_reorde=
r_ampdu.
> > > This check has been broken by 511fe3f3c4ba0b5b77421336f64a19b6cd0=
0e65f
> > > 'mac80211: rx.c use new helpers'
> > >=20
> > Actually, do we want something like this instead:
> >

Or, after having a coffee and actually engaging brain (similar to=20
ieee80211_is_data_qos)

int ieee80211_is_data_nullfunc(__le16 fc)
{
	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE | =EF=BB=BFIEEE80211_=EF=
=BB=BFSTYPE_NULLFUNC)) =3D=3D
		cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_NULLFUNC);
}

Tomas, you want a patch?

Harvey

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

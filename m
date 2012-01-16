Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:58335 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab2APMmX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jan 2012 07:42:23 -0500
Received: from thor.infotech.tu-chemnitz.de ([134.109.4.200] helo=[10.0.20.2])
	by cora.hrz.tu-chemnitz.de with esmtpsa (TLSv1:CAMELLIA256-SHA:256)
	(Exim 4.76)
	(envelope-from <marco.porsch@etit.tu-chemnitz.de>)
	id 1RmlTX-0006Zp-1n
	for linux-wireless@vger.kernel.org; Mon, 16 Jan 2012 13:15:47 +0100
Message-ID: <4F1414F3.7020007@etit.tu-chemnitz.de> (sfid-20120116_134227_470249_C757A432)
Date: Mon, 16 Jan 2012 13:15:47 +0100
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: possible bug in sta_info.c : ieee80211_send_null_response
Content-Type: multipart/mixed;
 boundary="------------050905060008050804000302"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050905060008050804000302
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

in this function there is some effort to set the EOSP flag in QoS Null 
frames:

if (reason == IEEE80211_FRAME_RELEASE_UAPSD)
	nullfunc->qos_ctrl |=
		cpu_to_le16(IEEE80211_QOS_CTL_EOSP);

ieee80211_xmit is called at the end of the function. Which then calls 
ieee80211_set_qos_hdr.

But ieee80211_set_qos_hdr will completely overwrite the QoS header again.
So, what is wrong here?

Regards
Marco



--------------050905060008050804000302
Content-Type: text/x-vcard; charset=utf-8;
 name="marco_porsch.vcf"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="marco_porsch.vcf"

begin:vcard
fn:Marco Porsch
n:Porsch;Marco
org:Chemnitz University of Technology;Communication Networks
adr;quoted-printable;quoted-printable:Fakult=3DC3=3DA4t f=3DC3=3DBCr Elek=
trotechnik und Informationstechnik , Professur=3D
	 Kommunikationsnetze;;Technische Universit=3DC3=3DA4t Chemnitz;Chemnitz;=
;D - 09107;Germany
email;internet:marco.porsch@etit.tu-chemnitz.de
title:Dipl.-Ing.
tel;work:+49 371 531 37523
version:2.1
end:vcard


--------------050905060008050804000302--

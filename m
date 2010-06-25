Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58403 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579Ab0FYRne convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jun 2010 13:43:34 -0400
Received: by iwn41 with SMTP id 41so2219693iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jun 2010 10:43:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinHfFVr45OV3V6CT9auK3L-JfrCYUMQpeo9toTw@mail.gmail.com>
References: <AANLkTinHfFVr45OV3V6CT9auK3L-JfrCYUMQpeo9toTw@mail.gmail.com>
Date: Fri, 25 Jun 2010 14:43:31 -0300
Message-ID: <AANLkTimeR5kQX2hSNw0Ud0QOF0-nsqCFMkSNul9wwa7C@mail.gmail.com>
Subject: Fwd: mesh configuration information element is wrong?
From: Iuri Diniz <iuridiniz@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello folks,

I'm analyzing the 802.11s code and I think I've found that mesh
configuration information element has wrongs sizes.

It is not according to my copy of 802.11s draft 3.

on linux-wireless-testing/linux/include/ieee80211.h we have:
--------
/**
 * struct ieee80211_meshconf_ie
 *
 * This structure refers to "Mesh Configuration information element"
 */
struct ieee80211_meshconf_ie {
    u8 meshconf_psel;
    u8 meshconf_pmetric;
    u8 meshconf_congest;
    u8 meshconf_synch;
    u8 meshconf_auth;
    u8 meshconf_form;
    u8 meshconf_cap;
} __attribute__ ((packed));
----------

All fields have 1 byte, but according to
http://i45.tinypic.com/4ghhd1.jpg some of they must have 4 or 2 bytes

the function mesh.c:mesh_mgmt_ies_add uses those wrong sizes to
prepare the management frame.

Is there a new draft? or is there any reason to use those sizes?

(March 2009) Draft 3 802.11s MESH CONFIGURATION ELEMENT:
http://i45.tinypic.com/4ghhd1.jpg

--
Iuri Diniz
http://iuridiniz.com [Sou um agitador, não um advogado]
http://blog.igdium.com [Linux on Limbo]

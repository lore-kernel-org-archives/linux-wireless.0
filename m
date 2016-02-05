Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36876 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754710AbcBESUH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2016 13:20:07 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1aRkzE-00048j-Gw
	for linux-wireless@vger.kernel.org; Fri, 05 Feb 2016 19:20:05 +0100
Received: from jsc-id-wp46.jsc.nasa.gov ([128.157.160.13])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 05 Feb 2016 19:20:04 +0100
Received: from eric.hillary-1 by jsc-id-wp46.jsc.nasa.gov with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 05 Feb 2016 19:20:04 +0100
To: linux-wireless@vger.kernel.org
From: Eric Hillary <eric.hillary-1@nasa.gov>
Subject: carl9170 client RTS/CTS option being overridden by WAP's WMM option
Date: Fri, 5 Feb 2016 16:07:22 +0000 (UTC)
Message-ID: <loom.20160205T170355-618@post.gmane.org> (sfid-20160205_192012_121773_31150808)
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGFzIGFueW9uZSBleHBlcmllbmNlZCB0aGF0IFJUUy9DVFMgaGFuZHNoYWtpbmcgc3RvcHMgb2NjdXJyaW5nIGF0IHRoZQpjbGllbnQgaWYgdGhlIHRoZSBhY2Nlc3MgcG9pbnQgZW5hYmxlcyBXTU0/CgoKVXNpbmcgdGhlIGNhcmw5MTcwIGRyaXZlciB3aXRoIFJUUy9DVFMgaGFuZHNoYWtpbmcgZW5hYmxlZCBvbiBhIFVTQiAKVWJpcXVpdGkgU1I3MS1VU0IgKEF0aGVyb3MgQVI5MTcwIGJhc2VkIHdpcmVsZXNzIGFkYXB0ZXIpLiAgUlRTL0NUUyB3aWxsIApzdG9wIHdvcmtpbmcgd2hlbiBXTU0gaXMgZW5hYmxlZCBvbiB0aGUgV0FQLiAgCgpUaGUgbmV0d29yayBpcyBydW5uaW5nIGluIDgwMi4xMW4gQy1iYW5kICg1R0h6KSBjaGFubmVscyBpbiAKSW5mcmFzdHJ1Y3R1cmUgbW9kZSB3aXRoIGFuIEF0aGVyb3MgQVI5MzcwIGJhc2VkIEFjY2VzcyBQb2ludC4gIFdlIGFyZSAKdXNpbmcgUlRTL0NUUyBoYW5kc2hha2luZyB0byByZWR1Y2Ug4oCcSGlkZGVuIE5vZGXigJ0gZWZmZWN0cy4gIE90aGVyIApjbGllbnRzIGluIHRoZSBuZXR3b3JrIHJlcXVpcmUgV01NIHRvIGJlIGVuYWJsZWQuICBGb3IgcmVhc29ucyBjaXRlZCBpbiAKaHR0cDovL3d3dy5zbWFsbG5ldGJ1aWxkZXIuY29tL3dpcmVsZXNzL3dpcmVsZXNzLWZlYXR1cmVzLzMwOTM4LWRvbnQtCm1lc3Mtd2l0aC13bW0sIFdNTSBzaG91bGQgYmUgZW5hYmxlZCB0byBzdXBwb3J0IDgwMi4xMWUsIApyZXF1aXJlZCBmb3IgODAyLjExbiB0byB1c2UgSFQgKEhpZ2ggVGhyb3VnaHB1dCkgbGluayByYXRlcy4KCldpdGggdGhlIFdNTSB0dXJuZWQgT0ZGIGF0IHRoZSBBUCBhbmQgUlRTIHZhbHVlID0gMjU2IGF0IHRoZSBVYmlxdWl0aSAKY2xpZW50LCB0aGUgUlRTL0NUUyBoYW5kc2hha2UgZnVuY3Rpb25zIG5vcm1hbGx5LiAgV2l0aCBXTU0gdHVybmVkIE9OIGF0IAp0aGUgQVAgYW5kIFJUUyB2YWx1ZSA9IDI1NiBzdGlsbCBvbiBhdCB0aGUgY2xpZW50IG5vIFJUUy9DVFMgaGFuZHNoYWtlIApvY2N1cnMuICBUaGUgY2FybDkxNzAgY2xpZW50IHN0b3BzIHNlbmRpbmcgdGhlIFJUUywgYW5kIHRoZSBjYXJsMTk3MCAKY2xpZW50IGlnbm9yaW5nIHRoZSBDVFMgbWVzc2FnZXMgdHJhbnNtaXR0ZWQgYnkgdGhlIEFQLCBjYXVzaW5nIApjb2xsaXNpb25zIGJlY2F1c2Ugb2YgbXkg4oCcSGlkZGVuIE5vZGXigJ0gY29uZGl0aW9uLgoKSGFkIHRvIGdldCBzY29wZSBwbG90cyBvZiB0aGUgUkYgbmV0d29yayB0cmFmZmljIGJldHdlZW4gdGhlIEFQIGFuZCAKY2xpZW50IHRvIG9ic2VydmUgdGhpcyBoYXBwZW5pbmcuCgoKdGhhbmtzLApFcmlj


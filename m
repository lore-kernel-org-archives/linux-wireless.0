Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2399 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab1ECJg3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:29 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>
Subject: [PATCH 57/61] staging: brcm80211: remove unused functions from
 wlc_phy_qmath.c
Date: Tue, 3 May 2011 11:35:57 +0200
Message-ID: <1304415361-7813-58-git-send-email-arend@broadcom.com> (sfid-20110503_113658_570021_C821344D)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The phy code only uses a subset of functions in wlc_phy_qmath.c and
the remaining are unused so those have been removed to cleanup the
codebase.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_qmath.c |  381 --------------------
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_qmath.h |   38 --
 2 files changed, 0 insertions(+), 419 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_qmath.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_qmath.c
index 0617292..c98176f 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_qmath.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_qmath.c
@@ -19,67 +19,6 @@
 #include "wlc_phy_qmath.h"
 
 /*
-Description: This function saturate input 32 bit number into a 16 bit number.
-If input number is greater than 0x7fff then output is saturated to 0x7fff.
-else if input number is less than 0xffff8000 then output is saturated to 0xffff8000
-else output is same as input.
-*/
-s16 qm_sat32(s32 op)
-{
-	s16 result;
-	if (op > (s32) 0x7fff) {
-		result = 0x7fff;
-	} else if (op < (s32) 0xffff8000) {
-		result = (s16) (0x8000);
-	} else {
-		result = (s16) op;
-	}
-	return result;
-}
-
-/*
-Description: This function multiply two input 16 bit numbers and return the 32 bit result.
-This multiplication is similar to compiler multiplication. This operation is defined if
-16 bit multiplication on the processor platform is cheaper than 32 bit multiplication (as
-the most of qmath functions can be replaced with processor intrinsic instructions).
-*/
-s32 qm_mul321616(s16 op1, s16 op2)
-{
-	return (s32) (op1) * (s32) (op2);
-}
-
-/*
-Description: This function make 16 bit multiplication and return the result in 16 bits.
-To fit the result into 16 bits the 32 bit multiplication result is right
-shifted by 16 bits.
-*/
-s16 qm_mul16(s16 op1, s16 op2)
-{
-	s32 result;
-	result = ((s32) (op1) * (s32) (op2));
-	return (s16) (result >> 16);
-}
-
-/*
-Description: This function multiply two 16 bit numbers and return the result in 32 bits.
-This function remove the extra sign bit created by the multiplication by leftshifting the
-32 bit multiplication result by 1 bit before returning the result. So the output is
-twice that of compiler multiplication. (i.e. qm_muls321616(2,3)=12).
-When both input 16 bit numbers are 0x8000, then the result is saturated to 0x7fffffff.
-*/
-s32 qm_muls321616(s16 op1, s16 op2)
-{
-	s32 result;
-	if (op1 == (s16) (0x8000) && op2 == (s16) (0x8000)) {
-		result = 0x7fffffff;
-	} else {
-		result = ((s32) (op1) * (s32) (op2));
-		result = result << 1;
-	}
-	return result;
-}
-
-/*
 Description: This function make 16 bit unsigned multiplication. To fit the output into
 16 bits the 32 bit multiplication result is right shifted by 16 bits.
 */
@@ -159,34 +98,6 @@ s16 qm_sub16(s16 op1, s16 op2)
 }
 
 /*
-Description: This function make 32 bit subtraction and return the 32bit result.
-If the result overflow 32 bits, the output will be saturated to 32bits.
-*/
-s32 qm_sub32(s32 op1, s32 op2)
-{
-	s32 result;
-	result = op1 - op2;
-	if (op1 >= 0 && op2 < 0 && result < 0) {
-		result = 0x7fffffff;
-	} else if (op1 < 0 && op2 > 0 && result > 0) {
-		result = 0x80000000;
-	}
-	return result;
-}
-
-/*
-Description: This function multiply input 16 bit numbers and accumulate the result
-into the input 32 bit number and return the 32 bit accumulated result.
-If the accumulation result in overflow, then the output will be saturated.
-*/
-s32 qm_mac321616(s32 acc, s16 op1, s16 op2)
-{
-	s32 result;
-	result = qm_add32(acc, qm_mul321616(op1, op2));
-	return result;
-}
-
-/*
 Description: This function make a 32 bit saturated left shift when the specified shift
 is +ve. This function will make a 32 bit right shift when the specified shift is -ve.
 This function return the result after shifting operation.
@@ -211,16 +122,6 @@ s32 qm_shl32(s32 op, int shift)
 }
 
 /*
-Description: This function make a 32 bit right shift when shift is +ve.
-This function make a 32 bit saturated left shift when shift is -ve. This function
-return the result of the shift operation.
-*/
-s32 qm_shr32(s32 op, int shift)
-{
-	return qm_shl32(op, -shift);
-}
-
-/*
 Description: This function make a 16 bit saturated left shift when the specified shift
 is +ve. This function will make a 16 bit right shift when the specified shift is -ve.
 This function return the result after shifting operation.
@@ -255,25 +156,6 @@ s16 qm_shr16(s16 op, int shift)
 }
 
 /*
-Description: This function return the number of redundant sign bits in a 16 bit number.
-Example: qm_norm16(0x0080) = 7.
-*/
-s16 qm_norm16(s16 op)
-{
-	u16 u16extraSignBits;
-	if (op == 0) {
-		return 15;
-	} else {
-		u16extraSignBits = 0;
-		while ((op >> 15) == (op >> 14)) {
-			u16extraSignBits++;
-			op = op << 1;
-		}
-	}
-	return u16extraSignBits;
-}
-
-/*
 Description: This function return the number of redundant sign bits in a 32 bit number.
 Example: qm_norm32(0x00000080) = 23
 */
@@ -292,203 +174,6 @@ s16 qm_norm32(s32 op)
 	return u16extraSignBits;
 }
 
-/*
-Description: This function divide two 16 bit unsigned numbers.
-The numerator should be less than denominator. So the quotient is always less than 1.
-This function return the quotient in q.15 format.
-*/
-s16 qm_div_s(s16 num, s16 denom)
-{
-	s16 var_out;
-	s16 iteration;
-	s32 L_num;
-	s32 L_denom;
-	L_num = (num) << 15;
-	L_denom = (denom) << 15;
-	for (iteration = 0; iteration < 15; iteration++) {
-		L_num <<= 1;
-		if (L_num >= L_denom) {
-			L_num = qm_sub32(L_num, L_denom);
-			L_num = qm_add32(L_num, 1);
-		}
-	}
-	var_out = (s16) (L_num & 0x7fff);
-	return var_out;
-}
-
-/*
-Description: This function compute the absolute value of a 16 bit number.
-*/
-s16 qm_abs16(s16 op)
-{
-	if (op < 0) {
-		if (op == (s16) 0xffff8000) {
-			return 0x7fff;
-		} else {
-			return -op;
-		}
-	} else {
-		return op;
-	}
-}
-
-/*
-Description: This function divide two 16 bit numbers.
-The quotient is returned through return value.
-The qformat of the quotient is returned through the pointer (qQuotient) passed
-to this function. The qformat of quotient is adjusted appropriately such that
-the quotient occupies all 16 bits.
-*/
-s16 qm_div16(s16 num, s16 denom, s16 *qQuotient)
-{
-	s16 sign;
-	s16 nNum, nDenom;
-	sign = num ^ denom;
-	num = qm_abs16(num);
-	denom = qm_abs16(denom);
-	nNum = qm_norm16(num);
-	nDenom = qm_norm16(denom);
-	num = qm_shl16(num, nNum - 1);
-	denom = qm_shl16(denom, nDenom);
-	*qQuotient = nNum - 1 - nDenom + 15;
-	if (sign >= 0) {
-		return qm_div_s(num, denom);
-	} else {
-		return -qm_div_s(num, denom);
-	}
-}
-
-/*
-Description: This function compute absolute value of a 32 bit number.
-*/
-s32 qm_abs32(s32 op)
-{
-	if (op < 0) {
-		if (op == (s32) 0x80000000) {
-			return 0x7fffffff;
-		} else {
-			return -op;
-		}
-	} else {
-		return op;
-	}
-}
-
-/*
-Description: This function divide two 32 bit numbers. The division is performed
-by considering only important 16 bits in 32 bit numbers.
-The quotient is returned through return value.
-The qformat of the quotient is returned through the pointer (qquotient) passed
-to this function. The qformat of quotient is adjusted appropriately such that
-the quotient occupies all 16 bits.
-*/
-s16 qm_div163232(s32 num, s32 denom, s16 *qquotient)
-{
-	s32 sign;
-	s16 nNum, nDenom;
-	sign = num ^ denom;
-	num = qm_abs32(num);
-	denom = qm_abs32(denom);
-	nNum = qm_norm32(num);
-	nDenom = qm_norm32(denom);
-	num = qm_shl32(num, nNum - 1);
-	denom = qm_shl32(denom, nDenom);
-	*qquotient = nNum - 1 - nDenom + 15;
-	if (sign >= 0) {
-		return qm_div_s((s16) (num >> 16), (s16) (denom >> 16));
-	} else {
-		return -qm_div_s((s16) (num >> 16), (s16) (denom >> 16));
-	}
-}
-
-/*
-Description: This function multiply a 32 bit number with a 16 bit number.
-The multiplicaton result is right shifted by 16 bits to fit the result
-into 32 bit output.
-*/
-s32 qm_mul323216(s32 op1, s16 op2)
-{
-	s16 hi;
-	u16 lo;
-	s32 result;
-	hi = op1 >> 16;
-	lo = (s16) (op1 & 0xffff);
-	result = qm_mul321616(hi, op2);
-	result = result + (qm_mulsu321616(op2, lo) >> 16);
-	return result;
-}
-
-/*
-Description: This function multiply signed 16 bit number with unsigned 16 bit number and return
-the result in 32 bits.
-*/
-s32 qm_mulsu321616(s16 op1, u16 op2)
-{
-	return (s32) (op1) * op2;
-}
-
-/*
-Description: This function multiply 32 bit number with 16 bit number. The multiplication result is
-right shifted by 15 bits to fit the result into 32 bits. Right shifting by only 15 bits instead of
-16 bits is done to remove the extra sign bit formed by multiplication from the return value.
-When the input numbers are 0x80000000, 0x8000 the return value is saturated to 0x7fffffff.
-*/
-s32 qm_muls323216(s32 op1, s16 op2)
-{
-	s16 hi;
-	u16 lo;
-	s32 result;
-	hi = op1 >> 16;
-	lo = (s16) (op1 & 0xffff);
-	result = qm_muls321616(hi, op2);
-	result = qm_add32(result, (qm_mulsu321616(op2, lo) >> 15));
-	return result;
-}
-
-/*
-Description: This function multiply two 32 bit numbers. The multiplication result is right
-shifted by 32 bits to fit the multiplication result into 32 bits. The right shifted
-multiplication result is returned as output.
-*/
-s32 qm_mul32(s32 a, s32 b)
-{
-	s16 hi1, hi2;
-	u16 lo1, lo2;
-	s32 result;
-	hi1 = a >> 16;
-	hi2 = b >> 16;
-	lo1 = (u16) (a & 0xffff);
-	lo2 = (u16) (b & 0xffff);
-	result = qm_mul321616(hi1, hi2);
-	result = result + (qm_mulsu321616(hi1, lo2) >> 16);
-	result = result + (qm_mulsu321616(hi2, lo1) >> 16);
-	return result;
-}
-
-/*
-Description: This function multiply two 32 bit numbers. The multiplication result is
-right shifted by 31 bits to fit the multiplication result into 32 bits. The right
-shifted multiplication result is returned as output. Right shifting by only 31 bits
-instead of 32 bits is done to remove the extra sign bit formed by multiplication.
-When the input numbers are 0x80000000, 0x80000000 the return value is saturated to
-0x7fffffff.
-*/
-s32 qm_muls32(s32 a, s32 b)
-{
-	s16 hi1, hi2;
-	u16 lo1, lo2;
-	s32 result;
-	hi1 = a >> 16;
-	hi2 = b >> 16;
-	lo1 = (u16) (a & 0xffff);
-	lo2 = (u16) (b & 0xffff);
-	result = qm_muls321616(hi1, hi2);
-	result = qm_add32(result, (qm_mulsu321616(hi1, lo2) >> 15));
-	result = qm_add32(result, (qm_mulsu321616(hi2, lo1) >> 15));
-	result = qm_add32(result, (qm_mulu16(lo1, lo2) >> 15));
-	return result;
-}
-
 /* This table is log2(1+(i/32)) where i=[0:1:31], in q.15 format */
 static const s16 log_table[] = {
 	0,
@@ -609,69 +294,3 @@ void qm_log10(s32 N, s16 qN, s16 *log10N, s16 *qLog10N)
 
 	return;
 }
-
-/*
-Description:
-This routine compute 1/N.
-This routine reformates the given no N as N * 2^qN where N is in between 0.5 and 1.0
-in q.15 format in 16 bits. So the problem now boils down to finding the inverse of a
-q.15 no in 16 bits which is in the range of 0.5 to 1.0. The output is always between
-2.0 to 1. So the output is 2.0 to 1.0 in q.30 format. Once the final output format is found
-by taking the qN into account. Inverse is found with newton rapson method. Initially
-inverse (x) is guessed as 1/0.75 (with appropriate sign). The new guess is calculated
-using the formula x' = 2*x - N*x*x. After 4 or 5 iterations the inverse is very close to
-inverse of N.
-Inputs:
-N - number to which 1/N has to be found.
-qn - q format of N.
-sqrtN - address where 1/N has to be written.
-qsqrtN - address where q format of 1/N has to be written.
-*/
-#define qx 29
-void qm_1byN(s32 N, s16 qN, s32 *result, s16 *qResult)
-{
-	s16 normN;
-	s32 s32firstTerm, s32secondTerm, x;
-	int i;
-
-	normN = qm_norm32(N);
-
-	/* limit N to least significant 16 bits. 15th bit is the sign bit. */
-	N = qm_shl32(N, normN - 16);
-	qN = qN + normN - 16 - 15;
-	/* -15 is added to treat N as 16 bit q.15 number in the range from 0.5 to 1 */
-
-	/* Take the initial guess as 1/0.75 in qx format with appropriate sign. */
-	if (N >= 0) {
-		x = (s32) ((1 / 0.75) * (1 << qx));
-		/* input no is in the range 0.5 to 1. So 1/0.75 is taken as initial guess. */
-	} else {
-		x = (s32) ((1 / -0.75) * (1 << qx));
-		/* input no is in the range -0.5 to -1. So 1/-0.75 is taken as initial guess. */
-	}
-
-	/* iterate the equation x = 2*x - N*x*x for 4 times. */
-	for (i = 0; i < 4; i++) {
-		s32firstTerm = qm_shl32(x, 1);	/* s32firstTerm = 2*x in q.29 */
-		s32secondTerm =
-		    qm_muls321616((s16) (s32firstTerm >> 16),
-				  (s16) (s32firstTerm >> 16));
-		/* s32secondTerm = x*x in q.(29+1-16)*2+1 */
-		s32secondTerm =
-		    qm_muls321616((s16) (s32secondTerm >> 16), (s16) N);
-		/* s32secondTerm = N*x*x in q.((29+1-16)*2+1)-16+15+1 i.e. in q.29 */
-		x = qm_sub32(s32firstTerm, s32secondTerm);
-		/* can be added directly as both are in q.29 */
-	}
-
-	/* Bring the x to q.30 format. */
-	*result = qm_shl32(x, 1);
-	/* giving the output in q.30 format for q.15 input in 16 bits. */
-
-	/* compute the final q format of the result. */
-	*qResult = -qN + 30;	/* adjusting the q format of actual output */
-
-	return;
-}
-
-#undef qx
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_qmath.h b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_qmath.h
index 5f525db..3dcee1c 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_qmath.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_qmath.h
@@ -17,14 +17,6 @@
 #ifndef __QMATH_H__
 #define __QMATH_H__
 
-s16 qm_sat32(s32 op);
-
-s32 qm_mul321616(s16 op1, s16 op2);
-
-s16 qm_mul16(s16 op1, s16 op2);
-
-s32 qm_muls321616(s16 op1, s16 op2);
-
 u16 qm_mulu16(u16 op1, u16 op2);
 
 s16 qm_muls16(s16 op1, s16 op2);
@@ -35,44 +27,14 @@ s16 qm_add16(s16 op1, s16 op2);
 
 s16 qm_sub16(s16 op1, s16 op2);
 
-s32 qm_sub32(s32 op1, s32 op2);
-
-s32 qm_mac321616(s32 acc, s16 op1, s16 op2);
-
 s32 qm_shl32(s32 op, int shift);
 
-s32 qm_shr32(s32 op, int shift);
-
 s16 qm_shl16(s16 op, int shift);
 
 s16 qm_shr16(s16 op, int shift);
 
-s16 qm_norm16(s16 op);
-
 s16 qm_norm32(s32 op);
 
-s16 qm_div_s(s16 num, s16 denom);
-
-s16 qm_abs16(s16 op);
-
-s16 qm_div16(s16 num, s16 denom, s16 *qQuotient);
-
-s32 qm_abs32(s32 op);
-
-s16 qm_div163232(s32 num, s32 denom, s16 *qquotient);
-
-s32 qm_mul323216(s32 op1, s16 op2);
-
-s32 qm_mulsu321616(s16 op1, u16 op2);
-
-s32 qm_muls323216(s32 op1, s16 op2);
-
-s32 qm_mul32(s32 a, s32 b);
-
-s32 qm_muls32(s32 a, s32 b);
-
 void qm_log10(s32 N, s16 qN, s16 *log10N, s16 *qLog10N);
 
-void qm_1byN(s32 N, s16 qN, s32 *result, s16 *qResult);
-
 #endif				/* #ifndef __QMATH_H__ */
-- 
1.7.4.1


